import io;
import python;
s = python("""
import os, sys
print('HELLO')
""",
"""
repr(42)
""");
printf("s: %s", s);
