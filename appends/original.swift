import unix;
import files;
import string;

append(file f, string s) {

        string fName = filename(f);
        string original = read(f);
        string appended = strcat(original, s);
        file newFile < fName >;
        newFile = write(appended);
}

// Here is how I tested it
file example <"/ui/ncsa/jacobrh/example.txt">;
example = write("line1\n");
append(example, "line2\n");
