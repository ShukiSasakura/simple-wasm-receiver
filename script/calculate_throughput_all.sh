#!/usr/bin/env bash

TOP_DIR=$( dirname $0 )
LOG_DIR=$( echo "$1" | sed "s/\/$//" )

if [ -f "$LOG_DIR/throughput.stat" ]; then
    rm -f $LOG_DIR/throughput.stat
fi

for logfile in $( ls $LOG_DIR/*.log )
do
    logfile_name=$( basename $logfile )
    sender_num=$( echo "$logfile_name" | sed -E "s/^[0-9]{8}-[0-9]{6}-([0-9]+)-[0-9]+\.log$/\1/" )
    echo "$TOP_DIR/calculate_throughput.py $logfile > $LOG_DIR/$sender_num.tmp"
    $TOP_DIR/calculate_throughput.py $logfile > "$LOG_DIR/$sender_num.tmp"
done

echo "throughput" >> $LOG_DIR/throughput.stat
tmpfile_num=$( ls -l $LOG_DIR/*.tmp | wc -l )
for i in $( seq 1 $tmpfile_num )
do
    tmpfile=$LOG_DIR/$i.tmp
    echo "cat $tmpfile >> $LOG_DIR/throughput.stat"
    cat $tmpfile >> $LOG_DIR/throughput.stat
done

echo "rm -f $LOG_DIR/*.tmp"
rm -f $LOG_DIR/*.tmp
