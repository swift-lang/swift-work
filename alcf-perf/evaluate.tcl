
package provide evaluate 0.0

proc evaluate { i c } {
  if { $i < 3 } {
    return "1,2"
  }
  return ""
}
