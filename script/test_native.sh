#!/usr/bin/env bash

date=$(date +"%Y%m%d-%H%M%S")

TOPDIR=$(dirname $(dirname "$0"))
LOGDIR=$TOPDIR/log/native/$date

mkdir -p $LOGDIR

for TOTAL_N_SENDERS in $(seq 1 40)
do

    killall receiver

    num_messages=$((10000 / TOTAL_N_SENDERS))

    # invoke receiver
    $TOPDIR/receiver/target/release/receiver \
    > $LOGDIR/$date-$TOTAL_N_SENDERS-$num_messages.log&
    sleep 1

    # invoke sender
    for i in $(seq 1 $TOTAL_N_SENDERS)
    do
        $TOPDIR/sender/target/release/sender -m $num_messages&
    done

    sleep 4

done
