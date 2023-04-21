#!/bin/bash

# set the file name and location to export the data
file_name="k8s_resource_quotas.csv"
file_location="./csv/"

# create the file and write the headers
echo "Namespace,Resource Type,Hard Limit,Used Limit" > "${file_location}${file_name}"

# get the list of namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')

# loop through each namespace and export the resource quotas
for ns in ${namespaces}; do
  # get the resource quotas for the current namespace
  quotas=$(kubectl describe quota --namespace=${ns})

  # extract the hard limits and used limits for each resource type
  cpu_hard=$(echo "${quotas}" | awk '/Limits.*cpu/{getline; print}')
  cpu_used=$(echo "${quotas}" | awk '/Used.*cpu/{getline; print}')
  mem_hard=$(echo "${quotas}" | awk '/Limits.*memory/{getline; print}')
  mem_used=$(echo "${quotas}" | awk '/Used.*memory/{getline; print}')

  # write the data to the CSV file
  echo "${ns},CPU,\"${cpu_hard}\",\"${cpu_used}\"" >> "${file_location}${file_name}"
  echo "${ns},Memory,\"${mem_hard}\",\"${mem_used}\"" >> "${file_location}${file_name}"
done
