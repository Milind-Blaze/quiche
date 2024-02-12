import numpy as np
import pandas as pd 

# Read the csv file

df = pd.read_csv('../throughput_dl/throughput_dl_1GB.csv')

# Calculate the average throughput
time = df['Time']
recv_bytes = df["Recv_Bytes"]
rate = 8*recv_bytes/(time*10**6)

print(rate.mean())

