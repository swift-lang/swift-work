
package provide evaluate 0.0

# # Algorithm 1:
# proc evaluate { i c limit } {
#   if { $i < $limit } {
#     for { set j $c } { $j < $limit } { incr j } {
#       lappend L $j
#     }
#     return [ join $L "," ]
#   }
#   return ""
# }

set seeded false

# Algorithm 2:
proc evaluate { i c limit } {

  global env
  global seeded

  if { ! $seeded } {
    set salt [ expr [ clock seconds ] % 1000 ]
    expr { srand($env(ADLB_RANK_SELF) + $salt) }
    set seeded true
  }

  set r [ expr rand() ]
  if { $r < 0.5 } return ""

  if { $i < $limit } {
    for { set j $c } { $j < $limit * 2 } { incr j } {
      lappend L $j
    }
    return [ join $L "," ]
  }
  return ""
}
