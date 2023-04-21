#!/bin/bash

# Get a list of namespaces in the cluster
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Create a header row for the CSV file
echo "Namespace,Resource,Hard,Used" > resource_quotas.csv

# Loop through the namespaces and export their resource quotas to the CSV file
for ns in $namespaces
do
    # Get the resource quotas for the namespace
    quotas=$(kubectl get resourcequota -n $ns -o jsonpath='{.items[*].metadata.name}')

    # Loop through the resource quotas and export their usage to the CSV file
    for quota in $quotas
    do
        # Get the hard and used limits for the resource quota
        hard=$(kubectl get resourcequota $quota -n $ns -o jsonpath='{.status.hard}')
        used=$(kubectl get resourcequota $quota -n $ns -o jsonpath='{.status.used}')

        # Add a row to the CSV file with the namespace, resource, hard limit, and used limit
        echo "$ns,$quota,$hard,$used" >> resource_quotas.csv
    done
done
