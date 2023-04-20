#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found. Please install it and try again."
    exit 1
fi

# Get all namespaces in the cluster
namespaces=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}')

echo "Namespace,ResourceQuotaName,CPU,Memory"

# Loop through each namespace and get the resource quotas
for namespace in $namespaces; do
  quota_names=$(kubectl get quota -n $namespace -o jsonpath='{.items[*].metadata.name}')

  for quota_name in $quota_names; do
    cpu=$(kubectl get quota -n $namespace $quota_name -o jsonpath='{.spec.hard.cpu}')
    memory=$(kubectl get quota -n $namespace $quota_name -o jsonpath='{.spec.hard.memory}')

    echo "$namespace,$quota_name,$cpu,$memory"
  done
done
