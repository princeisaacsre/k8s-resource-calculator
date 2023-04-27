#!/bin/bash

# Set the namespace
NAMESPACE="<your_namespace_here>"

# Set the output CSV file
OUTPUT_FILE="resource_quota_attributes.csv"

# Write the CSV header to the output file
echo "Name,Namespace,Created,Resource,Used,Hard" > "${OUTPUT_FILE}"

# Get the resource quotas and parse the output
kubectl get resourcequota --namespace "${NAMESPACE}" -o json |
  jq -r '.items[] | .metadata.namespace as $ns | .metadata.name as $name | .metadata.creationTimestamp as $created | .status.used as $used | .spec.hard as $hard | ($used | to_entries[] | map({(.key): .value}) | add) as $usedMap | ($hard | to_entries[] | map({(.key): .value}) | add) as $hardMap | [$name, $ns, ($created | fromdate | strftime("%Y-%m-%d")), ($usedMap + $hardMap) | to_entries[]] | @csv' |
  awk -F, 'BEGIN{OFS=","} {print $1,$2,$3,$4,$5,$7}' |
  sed 's/"//g' >> "${OUTPUT_FILE}"
