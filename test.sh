#!/bin/bash

# Set the output file
output_file="resource_quotas.csv"

# Write the CSV header
echo "Namespace,Quota Name,CPU Limit,CPU Request,Memory Limit,Memory Request" > $output_file

# Get the list of namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Iterate through each namespace and extract resource quotas
for namespace in $namespaces; do
  quotas=$(kubectl get resourcequota -n $namespace -o json)

  if [ -n "$quotas" ]; then
    # Extract quota information and append to CSV
    kubectl get resourcequota -n $namespace -o json | \
    jq -r ".items[] | [
      \"$namespace\",
      .metadata.name,
      (.spec.hard.\"limits.cpu\" // \"N/A\"), (.spec.hard.\"requests.cpu\" // \"N/A\"),
      (.spec.hard.\"limits.memory\" // \"N/A\"), (.spec.hard.\"requests.memory\" // \"N/A\")
      ] | @csv" >> $output_file
  fi
done

echo "Resource quotas exported to $output_file"
