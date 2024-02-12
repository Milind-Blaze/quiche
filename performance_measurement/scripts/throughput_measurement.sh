#!/bin/bash

# Number of iterations to run the command
n_iterations=2

# Output CSV file
output_csv="./results.csv"

# Add CSV header
echo "Time,Recv_Bytes,Rate" > "$output_csv"

# Function to run the command and extract necessary data
run_and_extract() {
    output=$(env RUST_LOG=info cargo run --bin quiche-client -- https://127.0.0.1:4433/transfer_test_1G.htm --no-verify 2>&1)

    if [ $? -ne 0 ]; then
        echo "Command failed to execute. Output:"
        echo "$output"
        return 1
    fi

    # echo "fire"

    # Extract time and recv_bytes using grep and awk
    time=$(echo "$output" | grep -oP 'response\(s\) received in \K\d+\.\d+(?=s, closing)')
    recv_bytes=$(echo "$output" | grep -oP 'recv_bytes=\K\d+')
    
    echo "$time"
    echo "$recv_bytes"


    # if [ -n "$time" ] && [ -n "$recv_bytes" ]; then
    #     rate=$(echo "scale=2; $recv_bytes / $time" | bc)
    #     echo "$time,$recv_bytes,$rate"
    # else
    #     echo "N/A,N/A,N/A"
    # fi
}

# Run the command n_iterations times and append results to CSV
for i in $(seq 1 $n_iterations); do
    result=$(run_and_extract)
    echo "$result" >> "$output_csv"
done

echo "Script completed. Results stored in $output_csv."
