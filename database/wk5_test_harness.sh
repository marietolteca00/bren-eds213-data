#!/bin/bash
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# get current time and store it
start=$SECONDS

# Begin For-looop
for num_reps in $(seq "$num_reps"); do
    duckdb "$db_file" "$query"
done

# End time 
end=$SECONDS

# Compute elapsed time - Basic arithmetic.
elapsed=$((end - start))

# Division
avg=$(echo "scale=7; $elapsed/$num_reps" | bc)

# I|O redirect
echo "$label,$avg" >> "$csv_file"