#!/bin/bash

# Set the threshold for resource quota usage
THRESHOLD=50

# Run kubectl to get a list of namespaces and their resource quotas,
# and filter out the ones that are using less than 50% of their quotas
kubectl get namespaces -o json | \
  jq -r '.items[] | .metadata.name as $ns | .metadata.annotations."kubectl.kubernetes.io/last-applied-configuration" | fromjson.spec[]? | select(.kind=="ResourceQuota") | select(.metadata.namespace==$ns) | select((.status.hard | to_entries)[] | .value != null and (.status.used | to_entries)[] | .value != null and (.status.used | to_entries)[] | .value / (.status.hard | to_entries)[] | .value * 100 < '$THRESHOLD') | $ns' | \
  sort | uniq | \
  awk 'BEGIN {FS="\n"; RS=""} {print "\"" $1 "\""}' | \
  sed -e '1i "Namespace"' > namespace_quotas.csv
