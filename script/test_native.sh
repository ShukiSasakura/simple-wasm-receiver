#!/usr/bin/env bash

date=$(date +"%Y%m%d-%H%M%S")

TOPDIR=$(dirname $(dirname "$0"))
LOGDIR=$TOPDIR/log/native/$date

mkdir -p $LOGDIR

for TOTAL_N_SENDERS in $(seq 1 40)
do

    echo "start sender num $TOTAL_N_SENDERS"
    killall receiver

    # message num that a receiver receive
    receive_messages_num=$((10000 - (10000 % TOTAL_N_SENDERS)))
    # message num that a sender send
    send_messages_num=$((10000 / TOTAL_N_SENDERS))

    # invoke a receiver
    $TOPDIR/receiver/target/release/receiver \
    > $LOGDIR/$date-$TOTAL_N_SENDERS-$receive_messages_num.log&
    sleep 1

    # invoke senders
    for i in $(seq 1 $TOTAL_N_SENDERS)
    do
        $TOPDIR/sender/target/release/sender -m $send_messages_num&
    done

    sleep 4

done
