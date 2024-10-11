#### Benchmark programs for comparing thread network performance between native and Wasmer
The effect of the number of Wasmer threads on performance is not much different from native when only CPU processing is performed, but when communication processing is included, the performance does not increase linearly.
This program is explaining this phenomenon.

<img src="https://github.com/ShukiSasakura/simple-wasm-receiver/blob/main/image/throughput-ratio.png" width="40%">

This figure shows the ratio of throughput when the benchmark was run with each thread count from 1 to 40 to the throughput with a thread count of 1.
The benchmark conditions are as follows:
+ Send message (TCP packet) from sender to receiver
+ Increase the number of senders from 1 to 40
+ Receive message with a dedicated thread for each sender
+ Send 10,000 messages to the receiver for measurements with each number of senders

The throughput (msg/s) is calculated from the time from the first message received to the last message received.

## Programs
| Directory Name | Description |
|:---------------|:------------|
| receiver       | A program that receives messages and returns acks |
| script         | Scripts for benchmark |
| sender         | A program that send messages and receive acks |

## Requirements
1. Rust
2. Wasmer
3. WASIX

## How to perform benchmark
1. Clone this repository
```
$ git clone git@github.com:ShukiSasakura/simple-wasm-receiver.git
```
2. Build receiver
```
$ cd simple-wasm-receiver/receiver
$ cargo build --release
$ cargo wasix build --release
```
3. Build sender
```
$ cd ../sender
$ cargo build --release
```
4. Prepare directories for logs
```
$ cd ..
$ mkdir log
$ mkdir log/native
$ mkdir log/wasm
```
5. Invoke benchmark programs
```
# kill receiver process if receiver process is running
$ killall receiver
$ killall wasmer

# invoke benchmark programs of native implementation
# When you run this program, the following directory and files are output:
# log/native/LOG_DIR/
# log/native/LOG_DIR/40 log files
$ ./script/test_native.sh

# invoke benchmark programs of wasm implementation
# When you run this program, the following directory and files are output:
# log/wasm/LOG_DIR/
# log/wasm/LOG_DIR/40 log files
$ ./script/test_wasmer.sh

# LOG_DIR format: YearMonthDate-HourMinuteSecond
# example: 20240807-143627
```
6. Calculate throughput
```
# When you run these programs, the following files are output:
# log/native/LOG_DIR/throughput.stat
# log/wasm/LOG_DIR/throughput.stat
$ ./script/calculate_throughput.py log/native/LOG_DIR
$ ./script/calculate_throughput.py log/wasm/LOG_DIR
```
7. ( Calculate average throughputs in LOG_DIRs )
```
# When you run these programs, the following files are output:
# log/native/throughput_average.stat
# log/wasm/throughput_average.stat
$ ./script/calculate_average_throughputs.sh log/native/
$ ./script/calculate_average_throughputs.sh log/wasm/
```
8. Make ratio graph
```
# When you run this program, the following file are output:
# GRAPH_FILE.pdf
# GRAPH_FILE format: YearMonthDate-HourMinuteSecond
# example: 20240807-143627.pdf

# make a graph of the logs in a single measurement
$ ./script/throughput_to_ratio_graph.py log/native/LOG_DIR/throughput.stat log/wasm/LOG_DIR/throughput.stat
# make an average graph of multiple measurement
$ ./script/throughput_to_ratio_graph.py log/native/throughput_average.stat log/wasm/throughput_average.stat
```
