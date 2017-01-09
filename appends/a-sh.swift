import unix;
import files;
import string;

app append(file f, string s) {
  "./a-sh.sh" f s ;
}

file example <"example.txt">;
example = write("line1\n");
append(example, "line2");
