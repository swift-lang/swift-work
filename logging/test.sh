#!/bin/zsh
set -eu

typeset -xT CLASSPATH classpath
classpath=( .
            log4j2/log4j-core-2.23.1.jar
            log4j2/log4j-1.2-api-2.23.1.jar
            log4j2/log4j-api-2.23.1.jar
          )
javac t1.java
java t1
