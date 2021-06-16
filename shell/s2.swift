app (file o) create(file i)
{
  "bash" "command.sh" i "--" o ;
}
app (file o) join(file i[])
{
  "bash" "command.sh" i "--" o ;
}

file null = input("/dev/null");
file a<"a.txt">;
file b<"b.txt">;
file c<"c.txt">;
file d<"d.txt">;

// The following lines can be reordered arbitrarily
a = create(null);
c = create(a);  
d = join([b,c]); // this will fire after b is created
b = create(a);   // b and c can be created concurrently
