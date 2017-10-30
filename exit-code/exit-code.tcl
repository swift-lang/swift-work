
proc system { args } {
  try {
    exec {*}$args
  } on error { e options } {
    return [ lindex [ dict get $options -errorcode ] 2 ]
    # or just
    # return 1
  }
  return 0
}
