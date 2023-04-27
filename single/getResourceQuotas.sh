#!/bin/bash

# Set the namespace
NAMESPACE="<your_namespace_here>"

# Set the output CSV file
OUTPUT_FILE="resource_quota.csv"

# Write the CSV header to the output file
echo "Name,Namespace,Age,Resource,Request,Limit" > "${OUTPUT_FILE}"

# Get the resource quotas and parse the output
kubectl get resourcequota --namespace "${NAMESPACE}" -o json |
  jq -r '.items[] | .metadata.namespace as $ns | .metadata.name as $name | .metadata.creationTimestamp as $created | .spec.hard as $hard | ($hard | to_entries[] | select(.key | startswith("requests.") or startswith("limits.")) ) as $entry | [$name, $ns, ($created | fromdate | strftime("%Y-%m-%d")), $entry.key, if $entry.key | startswith("requests.") then $entry.value else "N/A" end, if $entry.key | startswith("limits.") then $entry.value else "N/A" end] | @csv' |
  sed 's/"//g' >> "${OUTPUT_FILE}"
