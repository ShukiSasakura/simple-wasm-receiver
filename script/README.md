# Scripts for performance measurement

## Scripts
| Program Name | Description |
|:-------------|:------------|
| test_native.sh | A script to run a test once with native implementation |
| test_wasm.sh | A script to run a test once with wasm implementation |
| calculate\_throughput.py | A script to calculate throughput from the logfiles output by running test |
| calculate\_average\_throughputs.sh | A script that calculates the average throughput of each log directory in the argument directory and outputs |
| throughput\_to\_ratio\_graph.py | A script that outputs a graph from throughput |

## Command Format
### test_native.sh
```
./test_native.sh
```
#### Description
Start benchmark with receiver of native implementation.

### test_wasm.sh
```
./test_wasm.sh
```
#### Description
Start benchmark with receiver of wasm implementation.

### calculate_throughput.py
```
./calculate_throughput.py LOG_DIR
```
#### Description
Calculate throughput from logfiles in LOG_DIR.

#### Argument
**`LOG_DIR`**

Log directory output by running test.
LOG_DIR format is YMD-HMS
example: 20240807-143627

### calculate_average_throughputs.sh
```
./calculate_average_throughputs.sh LOG_DIRS_DIR
```

#### Description
Calculates the average throughput of each LOG_DIR in LOG_DIRS_DIR.

#### Argument
**`LOG_DIRS`**

Directory has LOG_DIRs output by test

### throughput_to_ratio_graph.py
```
./throughput_to_ratio_graph.py native_throughput_file wasm_throughput_file
```

#### Description
Outputs a graph from native_throughput_file and wasm_throughput_file.

#### Argument
**`native_throughput_file`**
**`wasm_throughput_file`**

Throughput file in the log directory output by calculate_throughput.py
