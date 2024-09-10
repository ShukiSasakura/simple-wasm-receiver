#### Benchmark programs for comparing thread network performance between native and Wasmer
The effect of the number of Wasmer threads on performance is not much different from native when only CPU processing is performed, but when communication processing is included, the performance does not increase linearly.
This program is explaining this phenomenon.

<img src="https://github.com/ShukiSasakura/simple-wasm-receiver/blob/main/image/throughput-ratio.png" width="40%">

This figure shows the ratio of throughput when the benchmark was run with each thread count from 1 to 40 to the throughput with a thread count of 1.
The conditions are as follows:
+ Increase the number of senders from 1 to 40
+ For measurements with each number of senders, send 10,000 messages to the receiver

This program continuously sends TCP packets to the receiver while increasing the number of senders from 1 to 40.
The receiver creates a dedicated thread for each sender.
The throughput (msg/s) is calculated from the time from the first message received to the last message received.

## Programs
| Directory Name | Description |
|:---------------|:------------|
| receiver       | A program that receives messages and returns acks |
| script         | Scripts for performance measurement |
| sender         | A program that send messages and receive acks |

<!-- ## Description for Programs -->
<!-- + Continuously send TCP packets to receiver while increasing sender from 1 to 40 -->
<!-- + Receiver invokes dedicaded thread for each sender and receive TCP packets (messages) -->

<!-- <img src="https://github.com/ShukiSasakura/simple-wasm-receiver/blob/main/image/simple-wasm-receiver.png" width="40%"> -->

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
# When you run this program, the following directories and files are output:
# log/native/LOG_DIR/
# log/native/LOG_DIR/40 log files
$ ./script/test_native.sh

# invoke benchmark programs of wasm implementation
# When you run this program, the following directories and files are output:
# log/wasm/LOG_DIR/
# log/wasm/LOG_DIR/40 log files
$ ./script/test_wasmer.sh

# LOG_DIR format: YearMonthDate-HourMinuteSecond
# example: 20240807-143627
```
6. Calculate throughput
```
$ ./calculate_throughput_all.sh ../log/native/LOG_DIR
$ ./calculate_throughput_all.sh ../log/wasm/LOG_DIR
# LOG_DIR format: YearMonthDate-HourMinuteSecond
# example: 20240807-143627
```
7. ( Calculate average throughputs in LOG_DIRs )
```
$ ./calculate_average_throughputs.sh ../log/native/
$ ./calculate_average_throughputs.sh ../log/wasm/
```
8. Make ratio graph

make a graph of the logs in a single measurement
```
$ ./throughput_to_ratio_graph.py ../log/native/LOG_DIR/throughput.stat ../log/wasm/LOG_DIR/throughput.stat
```
make an average graph of multiple measurement
```
$ ./throughput_to_ratio_graph.py ../log/native/throughput_average.stat ../log/wasm/throughput_average.stat
```
