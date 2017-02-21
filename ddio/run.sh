#!/bin/sh

set -e

echo "compiling..."
javac FakeWriter.java
echo "ok\n"

echo "running..."
java FakeWriter $*

