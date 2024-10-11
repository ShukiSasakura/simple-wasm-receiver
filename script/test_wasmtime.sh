#!/usr/bin/env bash

date=$(date +"%Y%m%d-%H%M%S")

TOPDIR=$(dirname $(dirname "$0"))
LOGDIR=$TOPDIR/log/wasmtime/$date

mkdir -p $LOGDIR

for TOTAL_N_SENDERS in $(seq 1 40)
do

    killall wasmtime

    num_messages=$((10000 / TOTAL_N_SENDERS))

    # invoke receiver
    wasmtime -S tcplisten="127.0.0.1:8000" -S threads $TOPDIR/receiver/target/wasm32-wasip1-threads/release/receiver.wasm \
    > $LOGDIR/$date-$TOTAL_N_SENDERS-$num_messages.log&
    sleep 1

    # invoke sender
    for i in $(seq 1 $TOTAL_N_SENDERS)
    do
        $TOPDIR/sender/target/release/sender -m $num_messages&
    done

    sleep 4

done
