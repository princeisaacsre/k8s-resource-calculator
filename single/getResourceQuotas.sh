#!/bin/bash

# Set the namespace
NAMESPACE="<your_namespace_here>"

# Set the output CSV file
OUTPUT_FILE="namespace_limits.csv"

# Write the CSV header to the output file
echo "Name,Age,Request(Jobs.batch),Request(Count),Limit(limits.cpu),Limit(limits.memory)" > "${OUTPUT_FILE}"

# Get the resource quotas and parse the output
kubectl get resourcequota --namespace "${NAMESPACE}" -o json |
  jq -r '.items[] | [.metadata.name, (.metadata.creationTimestamp | fromdate | strftime("%Y-%m-%d")), (.spec.hard["count/jobs.batch"] // "N/A"), (.spec.hard["requests.cpu"] // "N/A"), (.spec.hard["limits.cpu"] // "N/A"), (.spec.hard["limits.memory"] // "N/A")] | @csv' |
  sed 's/"//g' >> "${OUTPUT_FILE}"
