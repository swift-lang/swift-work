import unix;
import files;
import string;
import sys;

n = string2int(argv("n"));

@dispatch=WORKER
append(file f, int i, string s) "turbine" "1.0" [
"""
set    fd [ open [ turbine::local_file_path <<f>> ] r+ ]
seek  $fd [ expr <<i>> * 1024 ]
puts  $fd "record <<i>>: <<s>>"
close $fd
"""
];

file example <"example.txt">;
example = write("line1\n");
foreach i in [2:n] {
  append(example, i, "line"+i);
}
