#!/bin/bash

# Set the namespace
NAMESPACE="<your_namespace_here>"

# Set the output CSV file
OUTPUT_FILE="resource_quotas.csv"

# Write the CSV header to the output file
echo "Namespace,Resource,Used,Hard" > "${OUTPUT_FILE}"

# Get the resource quotas, parse the output, and append it to the CSV file
kubectl get resourcequota --namespace "${NAMESPACE}" -o json |
  jq -r '.items[] | .metadata.namespace as $ns | .status.used | to_entries[] | [ $ns, .key, .value ] | @csv' |
  sed 's/"//g' >> "${OUTPUT_FILE}"
