#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found. Please install it and try again."
    exit 1
fi

# Get all namespaces in the cluster
namespaces=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}')

echo "Resource quotas in the Kubernetes cluster:"

# Loop through each namespace and get the resource quotas
for namespace in $namespaces; do
  quotas=$(kubectl get quota -n $namespace -o custom-columns=NAME:.metadata.name,QUOTA:.spec.hard)

  if [ "$(echo "$quotas" | wc -l)" -gt "1" ]; then
    echo "Namespace: $namespace"
    echo "$quotas"
    echo ""
  fi
done
