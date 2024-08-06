#!/usr/bin/env bash

TOP_DIR=$( dirname $0 )
LOG_DIRS=$( echo "$1" | sed "s/\/$//" )

directories=$( ls $LOG_DIRS/ )

echo "throughput" > $LOG_DIRS/throughput_average.stat

for i in $( seq 2 41 )
do
    sum=0

    for logdir in $directories
    do
        throughput=$( sed -n "${i}p" "$LOG_DIRS/$logdir/throughput.stat" )
        sum=$( echo "$sum + $throughput" | bc )
    done

    average=$( echo "scale=2; $sum / 5" | bc )
    echo $average >> $LOG_DIRS/throughput_average.stat
done
