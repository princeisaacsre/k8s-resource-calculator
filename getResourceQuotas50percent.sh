#!/bin/bash

# Set the threshold for resource quota usage
THRESHOLD=50

# Get a list of namespaces in the cluster
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Loop through the namespaces and check their resource quota usage
for ns in $namespaces
do
    # Get the resource quota for the namespace
    quota=$(kubectl get resourcequota -n $ns -o jsonpath='{.items[0].status.hard}')

    # Get the resource usage for the namespace
    usage=$(kubectl get resourcequota -n $ns -o jsonpath='{.items[0].status.used}')

    # Calculate the percentage of resource quota usage
    usage_percentage=$(echo "scale=2; $usage/$quota*100" | bc)

    # Check if the usage percentage is less than the threshold
    if (( $(echo "$usage_percentage < $THRESHOLD" | bc -l) )); then
        echo "$ns is using $usage_percentage% of its resource quota"
    fi
done
