#!/bin/bash

# Set the output file
output_file="resource_quotas.csv"

# Write the CSV header
echo "Namespace,Quota Name,Age (days),Job Count,CPU Limit,Memory Limit" > $output_file

# Get the list of namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Function to calculate the age in days
get_age_in_days() {
  local creation_timestamp=$1
  local current_date=$(date +%s)
  local creation_date=$(date -d $creation_timestamp +%s)
  echo $(( (current_date - creation_date) / 86400 ))
}

# Iterate through each namespace and extract resource quotas
for namespace in $namespaces; do
  quotas=$(kubectl get resourcequota -n $namespace -o json)

  if [ -n "$quotas" ]; then
    # Extract quota information and append to CSV
    kubectl get resourcequota -n $namespace -o json | \
    jq -r --argjson now "$(date +%s)" '.items[] | [
      .metadata.namespace,
      .metadata.name,
      (($now - (.metadata.creationTimestamp | sub("\\.[0-9]+Z"; "Z") | fromdate)) / 86400 | floor),
      (.spec.hard."count.jobs.batch" // "N/A"),
      (.spec.hard."limits.cpu" // "N/A"),
      (.spec.hard."limits.memory" // "N/A")
      ] | @csv' >> $output_file
  fi
done

echo "Resource quotas exported to $output_file"
