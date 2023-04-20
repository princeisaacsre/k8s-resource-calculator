#!/bin/bash

# Set the namespace to check
NAMESPACE="your-namespace"

# Set the CSV output file name
OUTPUT_FILE="pod-utilization.csv"

# Write header to CSV file
echo "Pod,CPU Usage (mCPU),Memory Usage (Mi)" > $OUTPUT_FILE

# Get the list of pods in the namespace
POD_LIST=$(kubectl get pods --namespace=$NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through each pod and get its CPU and memory usage
for POD in $POD_LIST
do
  CPU_USAGE=$(kubectl top pod $POD --namespace=$NAMESPACE --containers | awk '{print $2}' | sed 's/m//' | awk '{sum+=$1} END {print sum}')
  MEMORY_USAGE=$(kubectl top pod $POD --namespace=$NAMESPACE --containers | awk '{print $3}' | sed 's/Mi//' | awk '{sum+=$1} END {print sum}')
  
  # Write pod utilization information to CSV file
  echo "$POD,$CPU_USAGE,$MEMORY_USAGE" >> $OUTPUT_FILE
done

echo "Pod utilization information written to $OUTPUT_FILE."
