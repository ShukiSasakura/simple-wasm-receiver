#!/usr/bin/env bash

date=$(date +"%Y%m%d-%H%M%S")

TOPDIR=$(dirname $(dirname "$0"))
LOGDIR=$TOPDIR/log/wasm/$date

mkdir -p $LOGDIR

for TOTAL_N_SENDERS in $(seq 1 40)
do

    killall wasmer

    num_messages=$((10000 / TOTAL_N_SENDERS))

    # invoke receiver
    wasmer --net $TOPDIR/receiver/target/wasm32-wasmer-wasi/release/receiver.wasm \
    > $LOGDIR/$date-$TOTAL_N_SENDERS-$num_messages.log&
    sleep 1

    # invoke sender
    for i in $(seq 1 $TOTAL_N_SENDERS)
    do
        $TOPDIR/sender/target/release/sender -m $num_messages&
    done

    sleep 4

done
