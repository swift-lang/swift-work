
# Assemble the library shared object file name
set libext "./libext[info sharedlibextension]"

# Load the library
load $libext

# Call the function in the library:
f
