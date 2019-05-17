// returns a void for data dependencies on void
app (file o, void v) create(file i)
{
  "bash" "command.sh" i "--" o ;
}
// this app blocks on d but does not use it
app (file o, void v) create_dummy(file i, file d)
{
  "bash" "command.sh" i "--" o ;
}

file null = input("/dev/null");
file a<"a.txt">;
file b<"b.txt">;
file c<"c.txt">;
void w1, w2, w3;

// force b to run after a, even though there is no file dependency
// but there is a dependency on void
wait (w1) {
  (b, w2) = create(null);
}
(a, w1) = create(null);

(c, w3) = create_dummy(a, null);
