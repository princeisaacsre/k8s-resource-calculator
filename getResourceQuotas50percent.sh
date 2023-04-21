#!/bin/bash

# Get a list of namespaces in the cluster
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Create a header row for the CSV file
echo "Namespace,CPU Used (%),Memory Used (%)" > resource_quota_usage.csv

# Loop through the namespaces and export their resource quota usage to the CSV file
for ns in $namespaces
do
    # Get the CPU usage percentage for the namespace
    cpu=$(kubectl top pods -n $ns --no-headers | awk '{ sum += $2 } END { printf "%.2f", sum }')
    cpu_quota=$(kubectl get resourcequota -n $ns -o jsonpath='{.items[*].spec.hard.cpu}')
    cpu_usage_percentage=$(echo "scale=2; $cpu / $cpu_quota * 100" | bc)

    # Get the memory usage percentage for the namespace
    memory=$(kubectl top pods -n $ns --no-headers | awk '{ sum += $3 } END { printf "%.2f", sum }')
    memory_quota=$(kubectl get resourcequota -n $ns -o jsonpath='{.items[*].spec.hard.memory}')
    memory_usage_percentage=$(echo "scale=2; $memory / $memory_quota * 100" | bc)

    # Add a row to the CSV file with the namespace, CPU usage percentage, and memory usage percentage
    echo "$ns,$cpu_usage_percentage,$memory_usage_percentage" >> resource_quota_usage.csv
done
