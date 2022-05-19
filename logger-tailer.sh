#!/usr/bin/env bash
set -e

function logger {
    while :
    do
        loggo=$[ $RANDOM % 10 + 2 ]
        sleepy=$[ $RANDOM % 60 + 10 ]
        the_date=$(date)
        echo "$sleepy $the_date" >> /var/log/date${loggo}.txt
        sleep $sleepy
    done
}

function tailer {

    tail -f /var/log/* &
    inotifywait -m -e create /var/log |
    while read dir ev file; do
        echo "$file"
        tail -f /var/log/${file} &
        # tail -f /var/log/${file} | sed -? /namefield timestampfield typefield logfield/jsonformat the things/ &
    done
    
}

if [ "$1" = 'logger' ]; then
    logger
else
    tailer
fi
