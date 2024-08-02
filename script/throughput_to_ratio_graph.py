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

#print(df_native_ratio)
#print(df_wasm_ratio)
#print(sender_num_label)

x = np.arange(len(sender_num_label))
#width = 0.4
#multiplier = 0

fig, ax = plt.subplots(layout='constrained')
#ax2 = ax.twinx()

# 棒グラフのプロット
#for implement, th roughput in throughputs.items():
#    offset = width * multiplier
#    rects = ax.bar(x + offset, throughput, width, label=implement, zorder=1)
#    #ax2.bar_label(rects, fmt='{:,.0f}', padding=3)
#    multiplier += 1

#h1, l1 = ax.get_legend_handles_labels()

# 折れ線グラフのプロット
#for implement, throughput in throughputs_ratio.items():
#    offset = width * multiplier
#    if implement == 'Native+MT':
#        rects = ax.plot(x, throughput, label=implement, marker='o', color='red')
#    elif implement == 'Wasm+MT':
#        rects = ax.plot(x, throughput, label=implement, marker='^', color='green')
#    multiplier += 1

df_native_ratio.plot(y='throughput', x=x, ax=ax, label="Native", marker='o', color='red')
df_wasm_ratio.plot(y='throughput', x=x, ax=ax, label="Wasm", marker='^', color='green')


h1, l1 = ax.get_legend_handles_labels()

#罫線
ax.grid()
ax.set_axisbelow(True)

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_xlabel('Sender num')
ax.set_ylabel('Throughput ratio')
#ax.set_ylabel('Throughput (msg/s)')

# 目盛り位置，上限値設定
ax.set_xticks(x, sender_num_label)

#ax2.legend(loc='upper left', ncols=2)
#ax.set_ylim(0, max(throughputs_ratio['Native+MT']) * 1.1)
ax.set_ylim(0, df_native_ratio.max() * 1.1)

#ax2.set_xticks(x + (width / 2), sender_num)
#ax.legend(loc='upper left', ncols=2)
#ax.set_ylim(0, max(throughputs['Native+MT']) * 1.1)

#ax.legend(h1+h2, l1+l2, loc='upper left', ncols=2)
ax.legend(h1, l1, loc='upper left', ncols=2)

plt.ticklabel_format(style='plain',axis='y')
#plt.xticks(rotation=30)
#plt.tick_params(labelsize=6)


# 棒グラフのプロット
# plt.bar(message_size, native_throughput, label='native')
# plt.bar(message_size, wasmedge_throughput, label='wasm')

# グラフの軸ラベル
# plt.xlabel('Message Size(KB)')
# plt.ylabel('Throughput(msgs/s)')

# グラフの pdf 出力
date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
file_name = f'{date}.pdf'

plt.savefig(file_name)
plt.close()
