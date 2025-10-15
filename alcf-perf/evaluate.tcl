
package provide evaluate 0.0

# Algorithm 1:
proc evaluate { i c limit } {
  set result ""
  if { $i < $limit } {
    for { set j $c } { $j < $limit } { incr j } {
      lappend L $j
    }
    set result [ join $L "," ]
  }
  show_step $i $c $result
  return $result
}

set seeded false

# # Algorithm 2:
# proc evaluate { i c limit } {

#   global seeded

#   if { ! $seeded } {
#     setup_rng
#   }

#   set result ""

#   set r [ expr rand() ]
#   if { $r > 0.1 } {
#     if { $i < $limit } {
#       for { set j $c } { $j < $limit } { incr j } {
#         lappend L $j
#       }
#       set result [ join $L "," ]
#     }
#   }
#   show_step $i $c $result
#   return $result
# }

proc setup_rng { } {

  global env
  global seeded

  set salt [ expr [ clock seconds ] % 1000 ]
  expr { srand($env(ADLB_RANK_SELF) + $salt) }
  set seeded true
}

proc show_step { i c L } {
  puts "step: $i $c : $L"
}
