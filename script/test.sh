#!/usr/bin/env bash

TOPDIR=$(dirname "$0")
SENDER="$TOPDIR/../sender/target/release/sender"
NATIVE_RECEIVER="$TOPDIR/../receiver/target/release/receiver"
WASM_RECEIVER="$TOPDIR/../receiver/target/wasm32-wasmer-wasi/release/receiver.wasm"

# parse option
usage() {
    echo "Usage: test.sh [-c N] [-s M] [-w]"
    echo " -c N Number of messages (default:10000)"
    echo " -s M Number of sender process (default:40)"
    echo " -w   Run receiver with wasmer"
}

# set default values
OPT_N_MESSAGES=10000
OPT_N_SENDERS=40
OPT_WASMER_FLAG=0

args=$(getopt -o c:hs:w -- "$@") || exit 1
eval "set -- $args"

while [ $# -gt 0 ]; do
  case "$1" in
    -h)
        OPT_ERROR=1;
        break ;;
    -c)
        OPT_N_MESSAGES=$2;
        shift 2 ;;
    -s)
        OPT_N_SENDERS=$2;
        shift 2   ;;
    -w)
        OPT_WASMER_FLAG=1;
        shift 1   ;;
    --)
        shift
        break;;
    *)
        shift
  esac
done

# unknown option check
if [ "$OPT_ERROR" = 1 ]; then
  usage
  exit 1
fi

# kill sender process
if [ $(ps -ax | grep sender | wc -l) != 1 ]; then
    killall sender
fi

# kill receiver process
if [ $(ps -ax | grep receiver | wc -l) != 1 ]; then
    killall receiver
fi

if [ $(ps -ax | grep wasmer | wc -l) != 1 ]; then
    killall wasmer
    sleep 1
fi

# invoke receiver
if [ $OPT_WASMER_FLAG -eq 0 ]; then
    command="$NATIVE_RECEIVER"
    $command&
    sleep 1
else
    command="wasmer --net $WASM_RECEIVER"
    $command&
    sleep 1
fi

# invoke sender
num_messages=$(expr $OPT_N_MESSAGES / $OPT_N_SENDERS)

for i in $(seq 1 $OPT_N_SENDERS)
do
    command="$SENDER -m $num_messages"
    $command&
done

sleep 4
