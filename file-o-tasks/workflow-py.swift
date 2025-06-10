
import io;
import files;
import sys;

// Cf. https://swift-lang.github.io/swift-t/guide.html#argv
listfile = argp(1);

printf("task list: '%s'", listfile);

// Cf. https://swift-lang.github.io/swift-t/guide.html#_i_o_with_files
L = file_lines(input(listfile));

foreach line in L
{
  printf("executing: '%s'", line);
  // Cf. https://swift-lang.github.io/swift-t/guide.html#stdlib_system
  s = python(line);
  printf("output: %i '%s'", code, s);
}
