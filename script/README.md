# Scripts for performance measurement

## Scripts
| Program Name | Description |
|:-------------|:------------|
| test.sh | A script to run a test once |
| run\_test\_change\_sender\_num.sh | A script to run tests multiple times with different sender numbers |
| calculate\_throughput.py | A script to calculate throughput from the logfiles output by run_test_change_sender_num.sh |
| calculate\_throughput\_all.sh | A script that applies calculate_throughput.py to all logfiles in the log directory output by run_test_change_sender_num.sh |
| calculate\_average\_throughputs.sh | Script that calculates the average throughput of each log directory in the argument directory and outputs it to a stat file (only supports 40 senders) | |
| throughput\_to\_ratio\_graph.py | A script that outputs a graph from throughput |

## Command Format
### test.sh
```
./test.sh [-c N] [-s M] [-w]
```
#### Description
Start and measure in the order receiver → sender according to the arguments given

#### Option
**`-c N`**

specify the number of messages N (default: 10000)

**`-s M`**

specify the number of senders M (default: 40)

**`-w`**

use wasmer and wasm receiver

### run_test_change_sender_num
```
./run_test_change_sender_num.sh [-c N] [-s M] [-w]
```
#### Description
Start test.sh by adjusting the number of messages while increasing the number of senders by one up to the given number.

#### Option
**`-c N`**

specify the base number of messages N (default: 10000). Based on N, calculate the number of messages that can be divided by the number of senders and start test.sh.

**`-s M`**

specify the max number of senders M (default: 40). start test.sh while increasing the number of senders by one from 1 to M.

**`-w`**

use wasmer and wasm receiver.

### calculate_throughput.py
```
./calculate_throughput.py logfile
```
#### Description
Calculate throughput from logfile.

#### Argument
**`logfile`**

Logfile output by run_test_change_sender_num.sh

### calculate_throughput_all.sh
```
./calculate_throughput_all.sh LOG_DIR
```
#### Description
Apply calculate_throughput.py to all logfiles in LOG_DIR.

#### Argument
**`LOG_DIR`**

Log directory output by run_test_change_sender_num.sh

### calculate_average_throughputs.sh
```
./calculate_average_throughputs.sh LOG_DIRS
```

#### Description
Calculates the average throughput of each log directory in LOG_DIRS.
(only supports 40 senders)

#### Argument
**`LOG_DIRS`**

Directory has LOG_DIRs output by run_test_change_sender_num

### throughput_to_ratio_graph.py
```
./throughput_to_ratio_graph.py native_throughput_file wasm_throughput_file
```

#### Description
Outputs a graph from native_throughput_file and wasm_throughput_file.

#### Argument
**`native_throughput_file`**

Throughput file in the native implementation log directory output by calculate_throughput_all.sh

**`wasm_throughput_file`**

Throughput file in the wasm implementation log directory output by calculate_throughput_all.sh
