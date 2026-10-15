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
set ready   { {0.0 1 0} }   ;# {ready_time i c}: the root is search(1,0)
set events  {}        ;# {end_time i} for tasks in flight

# Record a change in concurrency as two points, so the plot steps
# rather than sloping between events.
proc sample { t before after_ } {
  global samples
  lappend samples [ list $t $before ]
  lappend samples [ list $t $after_ ]
}

proc min_ready_time { } {
  global ready now
  set best ""
  foreach r $ready {
    set t [ lindex $r 0 ]
    if { $t > $now && ($best eq "" || $t < $best) } { set best $t }
  }
  return $best
}

while { [ llength $ready ] > 0 || [ llength $events ] > 0 } {

  # Start every ready task we have capacity for
  while { 1 } {
    if { $WORKERS > 0 && $running >= $WORKERS } break
    set idx -1
    for { set k 0 } { $k < [ llength $ready ] } { incr k } {
      if { [ lindex [ lindex $ready $k ] 0 ] <= $now } { set idx $k ; break }
    }
    if { $idx < 0 } break

    lassign [ lindex $ready $idx ] rt i c
    set ready [ lreplace $ready $idx $idx ]

    lassign [ run_task $i $c $M ] secs children
    sample $now $running [ incr running ]
    incr started
    lappend events [ list [ expr {$now + $secs} ] $i $children ]
  }

  if { [ llength $events ] == 0 } {
    # Nothing in flight: jump to the next task that becomes ready
    set t [ min_ready_time ]
    if { $t eq "" } break
    set now $t
    continue
  }

  # Advance to the next completion, or to the next task becoming
  # ready if that happens first
  set t_end ""
  foreach e $events {
    set t [ lindex $e 0 ]
    if { $t_end eq "" || $t < $t_end } { set t_end $t }
  }
  set t_ready [ min_ready_time ]
  if { $t_ready ne "" && $t_ready < $t_end } {
    set now $t_ready
    continue
  }
  set now $t_end

  # Retire everything finishing now, releasing their children
  set keep {}
  foreach e $events {
    lassign $e t i children
    if { $t > $now } { lappend keep $e ; continue }
    sample $now $running [ incr running -1 ]

    incr completed
    if { $PROGRESS > 0 && $completed % $PROGRESS == 0 } {
      puts stderr [ format \
        "sim: %d tasks done, t=%.1fs, %d running, %d ready" \
        $completed $now $running [ llength $ready ] ]
      flush stderr
    }
    foreach token $children {
      lappend ready [ list $now [ expr {$i+1} ] $token ]
    }
  }
  set events $keep
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
