#!/bin/bash  

startme() {
    sleep 60 &
}

stopme() {
    pkill -f "sleep"
}

case "$1" in 
    start)   startme ;;
    stop)    stopme ;;
    restart) stopme; startme ;;
    *) echo "usage: $0 start|stop|restart" >&2
       exit 1
       ;;
esac
