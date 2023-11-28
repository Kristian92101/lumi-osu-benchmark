import matplotlib.pyplot as plt
import numpy as np
import csv

filenames = ["GCD_0_to_GCD_1",\
"GCD_0_to_GCD_6",\
"GCD_0_to_GCD_2",\
"GCD_0_to_GCD_3",\
"GCD_0_to_GCD_7",\
"GCD_0_to_GCD_4"]

data = {}
plt.figure()
for filename in filenames:
    with open("./osu-micro-benchmarks-7.3/{}.csv".format(filename), newline='') as csvfile:
        x = []
        y = []
        csvreader = csv.reader(csvfile, delimiter=',')
        header = True
        for row in csvreader:
            if header:
                header = False
                continue
            y.append(float(row[1]))
            x.append(int(row[0]))
        data[filename] = [np.array(x), np.array(y)]
            
    plt.plot(data[filename][0], data[filename][1], label=filename)
plt.xscale('log')

plt.xlabel("Size [bytes]")
plt.ylabel("Bandwidth [MB/s]")
plt.title("GPU to GPU bandwidth")
plt.legend()
plt.savefig("GPU-to-GPU-bw.pdf")


filenames = ["NUMA_3_CCX_6_to_GCD_0",\
"NUMA_3_CCX_7_to_GCD_0",\
"NUMA_1_CCX_2_to_GCD_0",\
"NUMA_0_CCX_0_to_GCD_0",\
"NUMA_2_CCX_5_to_GCD_0"]

data = {}
plt.figure()
for filename in filenames:
    with open("./osu-micro-benchmarks-7.3/{}.csv".format(filename), newline='') as csvfile:
        x = []
        y = []
        csvreader = csv.reader(csvfile, delimiter=',')
        header = True
        for row in csvreader:
            if header:
                header = False
                continue
            y.append(float(row[1]))
            x.append(int(row[0]))
        data[filename] = [np.array(x), np.array(y)]
            
    plt.plot(data[filename][0], data[filename][1], label=filename)
plt.xscale('log')

plt.xlabel("Size [bytes]")
plt.ylabel("Bandwidth [MB/s]")
plt.title("CPU to GPU bandwidth")
plt.legend()
plt.savefig("CPU-to-GPU-bw.pdf")


filenames = ["NODE_0_GCD_0_to_NODE_1_GCD_0",\
"NODE_0_GCD_1_to_NODE_7_GCD_0"]

data = {}
plt.figure()
for filename in filenames:
    with open("./osu-micro-benchmarks-7.3/{}.csv".format(filename), newline='') as csvfile:
        x = []
        y = []
        csvreader = csv.reader(csvfile, delimiter=',')
        header = True
        for row in csvreader:
            if header:
                header = False
                continue
            y.append(float(row[1]))
            x.append(int(row[0]))
        data[filename] = [np.array(x), np.array(y)]
            
    plt.plot(data[filename][0], data[filename][1], label=filename)
plt.xscale('log')

plt.xlabel("Size [bytes]")
plt.ylabel("Bandwidth [MB/s]")
plt.title("Network GPU to GPU bandwidth")
plt.legend()
plt.savefig("In-between-nodes-bw.pdf")