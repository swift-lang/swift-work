#!/usr/bin/env tclsh

# SIM
#
# Simulate the search.swift workload without actually waiting.
#
# evaluate.tcl paces itself with [ after $delay ].  Here we intercept
# [ after ] so that it records the delay and returns immediately, then
# replay the workflow as a discrete-event simulation using those delays
# as the task durations.  The recursion and fanout therefore come from
# the real evaluate proc, not from a reimplementation of it.
#
# Output is a two-column data file for jwplot: time (seconds) against
# the number of evaluate calls running at that time.
#
# Usage:
#   tclsh sim.tcl [-m M] [-workers N] [-seed S] [-o FILE]
#
#   -m        recursion/fanout limit, as passed to search.swift (default 3)
#   -workers  concurrent tasks allowed; 0 means unlimited, which shows
#             the parallelism the workflow itself offers (default 0)
#   -seed     RNG seed, for a reproducible run (default 1)
#   -o        output data file (default sim.data)
#   -progress report progress every N completed tasks; 0 to disable
#             (default 1000).  Goes to stderr, so stdout stays clean.

set THIS [file dirname [file normalize [info script]]]

# ---------------------------------------------------------------- after

# Capture the delay instead of sleeping.  Anything that is not a plain
# "after <ms>" is passed through untouched.
rename after sim_real_after

set sim_delay 0

proc after { args } {
  global sim_delay
  if { [ llength $args ] == 1 &&
       [ string is integer -strict [ lindex $args 0 ] ] } {
    set sim_delay [ lindex $args 0 ]
    return
  }
  return [ sim_real_after {*}$args ]
}

source $THIS/evaluate.tcl

# ------------------------------------------------------------ arguments

proc usage { } {
  puts "Usage:"
  puts "  tclsh sim.tcl \[-m M\] \[-workers N\] \[-seed S\] \[-o FILE\]"
  puts "                \[-progress N\]"
  puts ""
  puts "  -m        recursion/fanout limit, as passed to search.swift"
  puts "            (default 3)"
  puts "  -workers  concurrent tasks allowed; 0 means unlimited,"
  puts "            which shows the parallelism the workflow itself"
  puts "            offers (default 0)"
  puts "  -seed     RNG seed, for a reproducible run (default 1)"
  puts "  -o        output data file (default sim.data)"
  puts "  -progress report progress every N completed tasks; 0 to"
  puts "            disable (default 1000).  Goes to stderr, so"
  puts "            stdout stays clean."
  puts "  -h        print this help and exit"
}

if { "-h" in $argv || "--help" in $argv } {
  usage
  exit 0
}

array set opt { -m 3 -workers 0 -seed 1 -o sim.data -progress 1000 }

for { set i 0 } { $i < [ llength $argv ] } { incr i 2 } {
  set flag [ lindex $argv $i ]
  if { ! [ info exists opt($flag) ] } {
    puts stderr "sim.tcl: unknown option: $flag"
    exit 1
  }
  set opt($flag) [ lindex $argv [ expr {$i+1} ] ]
}

set M        $opt(-m)
set WORKERS  $opt(-workers)
set PROGRESS $opt(-progress)

expr { srand($opt(-seed)) }

# ---------------------------------------------------------------- queue
#
# The "ready" set, as a FIFO queue.  Every entry gets ready_time ==
# the simulation clock at the moment it is pushed, and the clock only
# moves forward, so the queue is already non-decreasing in ready_time
# by construction: pushing is always a tail append.  A read-pointer
# (Qhead) avoids the O(n) lreplace / linear scan a plain list would
# need on every pop, with no change to processing order (so a given
# -seed still reproduces the same run; see below).
#
# A time-keyed heap looks tempting here, but would be wrong: when
# several tasks become ready at the same instant (e.g. one task's
# several children), a heap may pop them in a different relative
# order than they were inserted.  evaluate.tcl draws from the shared
# RNG (rand()), so reordering same-instant tasks changes the sequence
# random draws are consumed in, which changes the simulated run for a
# given -seed.  The queue preserves the original FIFO order exactly.

set Q     {}
set Qhead 0

proc q_push { t i c } {
  global Q
  lappend Q [ list $t $i $c ]
}

# Smallest ready_time still queued, or "" if empty.  O(1).
proc q_peek_time { } {
  global Q Qhead
  if { $Qhead >= [ llength $Q ] } { return "" }
  return [ lindex [ lindex $Q $Qhead ] 0 ]
}

proc q_pop { } {
  global Q Qhead
  set item [ lindex $Q $Qhead ]
  incr Qhead
  # Periodically drop the consumed prefix so Q doesn't grow without
  # bound over a long run.
  if { $Qhead > 1024 && $Qhead * 2 > [ llength $Q ] } {
    set Q [ lrange $Q $Qhead end ]
    set Qhead 0
  }
  return $item
}

proc q_size { } {
  global Q Qhead
  return [ expr { [ llength $Q ] - $Qhead } ]
}

# ----------------------------------------------------------------- heap
#
# "events" (tasks in flight) is the one set where order is genuinely
# unpredictable: each task's duration is an independent rand() draw
# (see evaluate.tcl), so end_time is not monotonic with start order.
# Every outer-loop iteration needs the smallest end_time, and there
# can be thousands in flight at once, so this is a real min-heap, keyed
# on (end_time, seq).  seq is a strictly increasing insertion counter
# used only to break exact end_time ties in original start order, so
# that a given -seed still reproduces the same run: an unordered tie
# would hand two same-instant finishers' children to the ready queue
# in an arbitrary order instead of the order they were started in.

array set E {}
set Esize 0
set Eseq  0

# True if heap slot a sorts at or before slot b.
proc e_leq { a b } {
  global E
  if { $E($a,t) != $E($b,t) } { return [ expr { $E($a,t) < $E($b,t) } ] }
  return [ expr { $E($a,seq) <= $E($b,seq) } ]
}

proc e_swap { a b } {
  global E
  foreach f { t seq i c } {
    set tmp $E($a,$f)
    set E($a,$f) $E($b,$f)
    set E($b,$f) $tmp
  }
}

proc e_push { t i children } {
  global E Esize Eseq
  incr Esize
  incr Eseq
  set E($Esize,t)   $t
  set E($Esize,seq) $Eseq
  set E($Esize,i)   $i
  set E($Esize,c)   $children
  set idx $Esize
  while { $idx > 1 } {
    set parent [ expr { $idx / 2 } ]
    if { [ e_leq $parent $idx ] } break
    e_swap $parent $idx
    set idx $parent
  }
}

# Smallest end_time in flight, or "" if nothing is in flight.  O(1).
proc e_peek_time { } {
  global E Esize
  if { $Esize == 0 } { return "" }
  return $E(1,t)
}

# Remove and return the {end_time i children} entry with the smallest
# end_time (ties broken by start order).
proc e_pop { } {
  global E Esize
  if { $Esize == 0 } { return "" }
  set result [ list $E(1,t) $E(1,i) $E(1,c) ]
  set E(1,t)   $E($Esize,t)
  set E(1,seq) $E($Esize,seq)
  set E(1,i)   $E($Esize,i)
  set E(1,c)   $E($Esize,c)
  unset E($Esize,t) E($Esize,seq) E($Esize,i) E($Esize,c)
  incr Esize -1
  set idx 1
  while { 1 } {
    set l [ expr { 2 * $idx } ]
    set r [ expr { 2 * $idx + 1 } ]
    set smallest $idx
    if { $l <= $Esize && ! [ e_leq $smallest $l ] } { set smallest $l }
    if { $r <= $Esize && ! [ e_leq $smallest $r ] } { set smallest $r }
    if { $smallest == $idx } break
    e_swap $idx $smallest
    set idx $smallest
  }
  return $result
}

proc e_size { } {
  global Esize
  return $Esize
}

# ----------------------------------------------------------- simulation

# Run one evaluate call.  Returns its children and, via the intercepted
# [ after ], how long the real workflow would have spent in it.
proc run_task { i c m } {
  global sim_delay
  set sim_delay 0
  set result [ evaluate $i $c $m ]
  set secs [ expr {$sim_delay / 1000.0} ]
  if { [ string length $result ] == 0 } {
    set children {}
  } else {
    set children [ split $result "," ]
  }
  return [ list $secs $children ]
}

set now     0.0
set running 0
set started 0
set completed 0
set samples {}        ;# {time count} pairs, a step function

q_push 0.0 1 0        ;# the root is search(1,0)

# Record a change in concurrency as two points, so the plot steps
# rather than sloping between events.
proc sample { t before after_ } {
  global samples
  lappend samples [ list $t $before ]
  lappend samples [ list $t $after_ ]
}

# Next ready_time strictly after $now, or "" if none.  Q is sorted by
# ready_time already, so this just scans past any entries left at or
# before $now (which only happens when a WORKERS cap stopped the start
# loop below from draining them) and stops at the first one past it.
proc min_ready_time { } {
  global Q Qhead now
  set n [ llength $Q ]
  for { set k $Qhead } { $k < $n } { incr k } {
    set t [ lindex [ lindex $Q $k ] 0 ]
    if { $t > $now } { return $t }
  }
  return ""
}

while { [ q_size ] > 0 || [ e_size ] > 0 } {

  # Start every ready task we have capacity for
  while { 1 } {
    if { $WORKERS > 0 && $running >= $WORKERS } break
    set rt [ q_peek_time ]
    if { $rt eq "" || $rt > $now } break
    lassign [ q_pop ] rt i c

    lassign [ run_task $i $c $M ] secs children
    sample $now $running [ incr running ]
    incr started
    e_push [ expr {$now + $secs} ] $i $children
  }

  if { [ e_size ] == 0 } {
    # Nothing in flight: jump to the next task that becomes ready
    set t [ min_ready_time ]
    if { $t eq "" } break
    set now $t
    continue
  }

  # Advance to the next completion, or to the next task becoming
  # ready if that happens first
  set t_end [ e_peek_time ]
  set t_ready [ min_ready_time ]
  if { $t_ready ne "" && $t_ready < $t_end } {
    set now $t_ready
    continue
  }
  set now $t_end

  # Retire everything finishing now, releasing their children
  while { 1 } {
    set t [ e_peek_time ]
    if { $t eq "" || $t > $now } break
    lassign [ e_pop ] t i children
    sample $now $running [ incr running -1 ]

    incr completed
    if { $PROGRESS > 0 && $completed % $PROGRESS == 0 } {
      puts stderr [ format \
        "sim: %d tasks done, t=%.1fs, %d running, %d ready" \
        $completed $now $running [ q_size ] ]
      flush stderr
    }
    foreach token $children {
      q_push $now [ expr {$i+1} ] $token
    }
  }
}

# --------------------------------------------------------------- output

set peak 0
set area 0.0
set prev_t 0.0
set prev_n 0
foreach s $samples {
  lassign $s t n
  if { $n > $peak } { set peak $n }
  set area [ expr {$area + $prev_n * ($t - $prev_t)} ]
  set prev_t $t
  set prev_n $n
}
set makespan $now

set fd [ open $opt(-o) w ]
# Several events can land on the same instant, so drop points that
# repeat the previous one: they add nothing to a step plot
set last ""
foreach s $samples {
  lassign $s t n
  set line [ format "%.3f\t%d" $t $n ]
  if { $line ne $last } {
    puts $fd $line
    set last $line
  }
}
# Close the series off at the end of the workflow
set line [ format "%.3f\t%d" $makespan 0 ]
if { $line ne $last } { puts $fd $line }
close $fd

puts [ format "M:        %d" $M ]
puts [ format "WORKERS:  %s" [ expr {$WORKERS == 0 ? "unlimited" : $WORKERS} ] ]
puts [ format "TASKS:    %d" $started ]
puts [ format "MAKESPAN: %.3f s" $makespan ]
puts [ format "PEAK:     %d concurrent" $peak ]
if { $makespan > 0 } {
  puts [ format "MEAN:     %.2f concurrent" [ expr {$area / $makespan} ] ]
}
puts "wrote: $opt(-o)"
