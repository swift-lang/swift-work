
echo FUNCTIONS.SH START

test_run()
{
  COMMAND=( ${*} )
  if ${COMMAND[@]}
  then
    echo OK
  else
    echo FAIL
    exit 1
  fi
}

echo FUNCTIONS.SH DONE
