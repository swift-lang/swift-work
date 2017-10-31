
trap handler SIGUSR1 SIGUSR2

handler()
{
  echo hi $*
}

while :
do
  sleep 1
done
