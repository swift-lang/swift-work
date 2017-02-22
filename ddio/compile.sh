if [[ ! -f FakeWriter.class ]] || [[ FakeWriter.java -nt FakeWriter.class ]]
then
  echo "compiling..."
  javac FakeWriter.java
  printf "ok\n\n"
fi
