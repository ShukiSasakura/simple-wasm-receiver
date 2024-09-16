#!/usr/bin/env python

import pandas as pd
import argparse
import re
import os
import glob
 
# get log_directory name from arg
parser = argparse.ArgumentParser()
parser.add_argument('logdirectory')
args = parser.parse_args()

# define function for natural sort
def natural_key(s):
    return [int(char) if char.isdecimal() else char for char in re.split('([0-9]+)', s) ]

# get log file list from log_directory
log_directory = args.logdirectory
csv_files = sorted(glob.glob(os.path.join(log_directory, '*.log')), key=natural_key)

with open(os.path.join(log_directory, 'throughput.stat'), 'w') as f:
    f.write('throughput\n')
    for csv_file in csv_files:
        # 1. get message_num from log file name
        # filename pattern
        # $date-sendernum-messagenum.log
        # example: 20240730-142011-2-1000.log
        csv_filename = os.path.basename(csv_file)
        filename_pattern = r'\d{8}-\d{6}-\d+-(\d+)\.log'
        match = re.search(filename_pattern, csv_filename)
        message_num = int(match.group(1))
        #
        # 2. make df about time from log file
        df_orig = pd.read_csv(csv_file, skipinitialspace=True)
        df = df_orig.sort_values('time')
        #
        # 3. calculate throughput and output it to throughput.stat in log_directory
        time = (df['time'].max() - df['time'].min()) / 1000000000
        throughput = message_num / time
        print(throughput, file=f)
