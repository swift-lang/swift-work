
source "exit-code.tcl"

foreach command [ list "true" "false" ] {
  set exit_code [ system $command ]
  puts "$command -> $exit_code"
}
