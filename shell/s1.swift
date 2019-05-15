app (file o) copy(file i)
{
  "bash" "command.sh" i o ;
}

file f1 = input("/dev/null");
file f2<"newfile.txt">;
f2 = copy(f1);
