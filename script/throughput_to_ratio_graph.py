#!/usr/bin/env python3

from matplotlib import pyplot as plt
from matplotlib import ticker
import numpy as np
import pypdf
import datetime
import pandas as pd
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('native_throughput_file')
parser.add_argument('wasm_throughput_file')
args = parser.parse_args()

native_throughput_file = args.native_throughput_file
wasm_throughput_file = args.wasm_throughput_file

df_native = pd.read_csv(native_throughput_file, skipinitialspace=True)
df_wasm = pd.read_csv(wasm_throughput_file, skipinitialspace=True)

df_native_ratio = df_native['throughput'] / df_native['throughput'][0]
df_wasm_ratio = df_wasm['throughput'] / df_wasm['throughput'][0]

sender_num_label = []

for i in range(40):
    if (i + 1) % 5 == 0:
        label = i + 1
        sender_num_label.append(label)
    else:
        sender_num_label.append('')

x = np.arange(len(sender_num_label))

fig, ax = plt.subplots(layout='constrained')

df_native_ratio.plot(y='throughput', x=x, ax=ax, label="Native", marker='o', color='red')
df_wasm_ratio.plot(y='throughput', x=x, ax=ax, label="Wasmer", marker='^', color='green')

h1, l1 = ax.get_legend_handles_labels()

ax.grid()
ax.set_axisbelow(True)

ax.set_xlabel('Sender num (Thread num)')
ax.set_ylabel('Throughput ratio')

ax.set_xticks(x, sender_num_label)

ax.set_ylim(0, df_native_ratio.max() * 1.1)

ax.legend(h1, l1, loc='upper left', ncols=2)

plt.ticklabel_format(style='plain',axis='y')

date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
file_name = f'{date}.pdf'

plt.savefig(file_name)
plt.close()
