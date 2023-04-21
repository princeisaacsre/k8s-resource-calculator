#!/bin/bash

# set the threshold for resource usage percentage
threshold=50

# get the list of namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')

# loop through each namespace and check resource usage
for ns in ${namespaces}; do
  # get the resource quota for the current namespace
  quota=$(kubectl describe quota --namespace=${ns})

  # extract the hard limits and used limits for each resource type
  cpu_hard=$(echo "${quota}" | awk '/Limits.*cpu/{getline; print}' | awk '{print $2}')
  cpu_used=$(echo "${quota}" | awk '/Used.*cpu/{getline; print}' | awk '{print $2}')
  mem_hard=$(echo "${quota}" | awk '/Limits.*memory/{getline; print}' | awk '{print $2}')
  mem_used=$(echo "${quota}" | awk '/Used.*memory/{getline; print}' | awk '{print $2}')

  # calculate the percentage of resource usage for each type
  cpu_percent=$(echo "scale=2; ${cpu_used}/${cpu_hard}*100" | bc)
  mem_percent=$(echo "scale=2; ${mem_used}/${mem_hard}*100" | bc)

  # check if any resource usage is below the threshold
  if (( $(echo "${cpu_percent} < ${threshold}" | bc -l) )) || (( $(echo "${mem_percent} < ${threshold}" | bc -l) )); then
    echo "${ns} is using less than ${threshold}% of its resource quota"
  fi
done
