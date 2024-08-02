#!/usr/bin/env bash

TOPDIR=$(dirname "$0")
date=$(date +"%Y%m%d-%H%M%S")

# parse option
usage() {
    echo "Usage: test.sh -s N [-c N]"
    echo " -c N Base number of messages (default:100000)"
    echo " -s N Max number of sender process"
    echo " -w   Run receiver with wasmer"
}

# set default values
OPT_N_MESSAGES_BASE=100000
OPT_WASMER_FLAG=0

args=$(getopt -o c:hs:w -- "$@") || exit 1
eval "set -- $args"

while [ $# -gt 0 ]; do
  case "$1" in
    -h)
        OPT_ERROR=1;
        break ;;
    -c)
        OPT_N_MESSAGES_BASE=$2;
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

# make log directory
if [ ! -d ../log ]; then
  mkdir ../log
  mkdir ../log/native
  mkdir ../log/wasm
fi

#prepare log
if [ $OPT_WASMER_FLAG -eq 0 ]; then
    if [ ! -d ../log/native/$date ]; then
        mkdir ../log/native/$date
    fi
else
    if [ ! -d ../log/wasm/$date ]; then
        mkdir ../log/wasm/$date
    fi
fi


if [ $OPT_WASMER_FLAG -eq 0 ]; then
    for N_SENDERS in $(seq 1 $OPT_N_SENDERS)
    do
        N_MASSAGES=$(( $OPT_N_MESSAGES_BASE-($OPT_N_MESSAGES_BASE%$N_SENDERS) ))
        log_name="$date-$N_SENDERS-$N_MASSAGES.log"
        command="$TOPDIR/test.sh -s $N_SENDERS -c $N_MASSAGES"
        echo "$command > ../log/native/$date/$log_name"
        $command > ../log/native/$date/$log_name
    done
else
    for N_SENDERS in $(seq 1 $OPT_N_SENDERS)
    do
        N_MASSAGES=$(( $OPT_N_MESSAGES_BASE-($OPT_N_MESSAGES_BASE%$N_SENDERS) ))
        log_name="$date-$N_SENDERS-$N_MASSAGES.log"
        command="$TOPDIR/test.sh -s $N_SENDERS -c $N_MASSAGES -w"
        echo "$command > ../log/wasm/$date/$log_name"
        $command > ../log/wasm/$date/$log_name
    done
fi
