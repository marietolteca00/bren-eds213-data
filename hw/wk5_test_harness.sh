#!/bin/bash
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# get current time and store it
start=$SECONDS


for i in $(seq $num_reps); do
    duckdb "$db_file" "$query"
done

# End time 
end=$SECONDS

# Get elapsed time
elapsed=$((end - start))

# Get avg
avg=$(echo "scale=7; $elapsed/$num_reps" | bc)
echo "$label,$avg" >> $csv_file