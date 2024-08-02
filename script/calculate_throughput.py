#!/usr/bin/env python

import pandas as pd
import argparse
import re
import os
 
parser = argparse.ArgumentParser()
parser.add_argument('csvfile')
args = parser.parse_args()

csv_file = args.csvfile
csv_filename = os.path.basename(csv_file)

# filename pattern
# $date-sendernum-messagenum.log
# example: 20240730-142011-2-1000.log
filename_pattern = r'\d{8}-\d{6}-\d+-(\d+)\.log'
match = re.search(filename_pattern, csv_filename)

message_num = int(match.group(1))

df_orig = pd.read_csv(csv_file, skipinitialspace=True)
df = df_orig.sort_values('time')

time = (df['time'].max() - df['time'].min()) / 1000000000
throughput = message_num / time
print(throughput)
