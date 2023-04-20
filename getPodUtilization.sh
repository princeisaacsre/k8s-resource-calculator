#!/bin/bash

# Set the namespace to check
NAMESPACE="your-namespace"

# Get the list of pods in the namespace
POD_LIST=$(kubectl get pods --namespace=$NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through each pod and get its CPU and memory usage
for POD in $POD_LIST
do
  CPU_USAGE=$(kubectl top pod $POD --namespace=$NAMESPACE --containers | awk '{print $2}' | sed 's/m//' | awk '{sum+=$1} END {print sum}')
  MEMORY_USAGE=$(kubectl top pod $POD --namespace=$NAMESPACE --containers | awk '{print $3}' | sed 's/Mi//' | awk '{sum+=$1} END {print sum}')
  
  echo "Pod $POD - CPU usage: $CPU_USAGE mCPU, Memory usage: $MEMORY_USAGE Mi"
done
