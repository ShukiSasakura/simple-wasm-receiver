#### Benchmark programs for comparing thread network performance between native and Wasmer
The effect of the number of Wasmer threads on performance is not much different from native when only CPU processing is performed, but when communication processing is included, the performance does not increase linearly.
This program for explaining this phenomenon.

![throughput ratio graph](https://github.com/ShukiSasakura/simple-wasm-receiver/blob/main/image/throughput-ratio.png)

## Programs
| Directory Name | Description |
|:---------------|:------------|
| receiver       | A program that receives messages and returns acks |
| script         | Scripts for performance measurement |
| sender         | A program that send messages and receive acks |

## Description for Programs
+ Continuously send TCP packets to receiver while increasing sender from 1 to 40
+ Receiver invokes dedicaded thread for each sender and receive TCP packets (messages)

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
4. Invoke benchmark programs
```
$ cd ../script
# invoke benchmark programs of native implementation
$ ./run_test_change_sender_num.sh
# invoke benchmark programs of wasm implementation
$ ./run_test_change_sender_num.sh -w
```
5. Calculate throughput
```
$ ./calculate_throughput_all.sh ../log/native/LOG_DIR
$ ./calculate_throughput_all.sh ../log/wasm/LOG_DIR
# LOG_DIR format: YearMonthDate-HourMinuteSecond
# example: 20240807-143627
```
6. ( Calculate average throughputs in LOG_DIRs )
```
$ ./calculate_average_throughputs.sh ../log/native/
$ ./calculate_average_throughputs.sh ../log/wasm/
```
7. Make ratio graph

make a graph of the logs in a single measurement
```
$ ./throughput_to_ratio_graph.py ../log/native/LOG_DIR/throughput.stat ../log/wasm/LOG_DIR/throughput.stat
```
make an average graph of multiple measurement
```
$ ./throughput_to_ratio_graph.py ../log/native/throughput_average.stat ../log/wasm/throughput_average.stat
```
