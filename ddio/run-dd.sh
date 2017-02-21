#!/bin/sh

set -e

echo "compiling..."
javac FakeWriter.java
echo "ok\n"

if [ -e fifo ]
then
  rm -v fifo
fi

mkfifo fifo
dd if=fifo of=output.txt &

echo "running..."
java FakeWriter $* fifo

