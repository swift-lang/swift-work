
import unix;

// app function to connect to chem.sh
app (file o) chem(string i, file f)
{
  "./chem.sh" i f @stdout=o ;
}

file f_A<"A.txt">;
file f_B<"B.txt">;
file f_C<"C.txt">;
file f_D<"D.txt">;

f_A = chem("A", input("/dev/null"));
f_B = chem("B", f_A);
f_C = chem("C", f_A);
f_D = cat([f_B, f_C]);
f_D => trace("DONE");
