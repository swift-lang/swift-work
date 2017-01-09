import unix;
import files;
import string;

@dispatch=WORKER
append(file f, string s) "turbine" "1.0" [
  "exec echo <<s>> >> [ turbine::local_file_path <<f>> ]"
];

file example <"example.txt">;
example = write("line1\n");
append(example, "line2");
