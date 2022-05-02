
import files;
import string;
import unix;
// file out <"tmp.txt"> = echo("HELLO");

file v = input("input.txt");
file out <sprintf("file-%s.txt",basename(v))> = echo("HELLO");

string s1 = basename(v);
trace(s1);
string s2 = rootname(v);
trace(s2);

string s3 = dirname(v);
trace(s3);

string s4 = extension(v);
trace(s4);
