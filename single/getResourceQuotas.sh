#!/bin/bash

# Set the namespace
NAMESPACE="<your_namespace_here>"

# Set the output CSV file
OUTPUT_FILE="namespace_resource_quota.csv"

# Write the CSV header to the output file
echo "Name,Namespace,Used(count/jobs.batch),Hard(count/jobs.batch),Used(limits.cpu),Hard(limits.cpu),Used(limits.memory),Hard(limits.memory)" > "${OUTPUT_FILE}"

# Get the resource quotas and parse the output
kubectl get resourcequota --namespace "${NAMESPACE}" -o json |
  jq -r '.items[] | [.metadata.name, .metadata.namespace, (.status.used["count/jobs.batch"] // "N/A"), (.spec.hard["count/jobs.batch"] // "N/A"), (.status.used["limits.cpu"] // "N/A"), (.spec.hard["limits.cpu"] // "N/A"), (.status.used["limits.memory"] // "N/A"), (.spec.hard["limits.memory"] // "N/A")] | @csv' |
  sed 's/"//g' >> "${OUTPUT_FILE}"
