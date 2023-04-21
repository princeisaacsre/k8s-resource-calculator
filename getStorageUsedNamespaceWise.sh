#!/bin/bash

# set the file name and location to export the data
file_name="k8s_storage_used.csv"
file_location="./csv/"

# create the file and write the headers
echo "Namespace,Storage Used" > "${file_location}${file_name}"

# get the list of namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')

# loop through each namespace and export the storage usage
for ns in ${namespaces}; do
  # get the storage usage for the current namespace
  storage=$(kubectl exec -it $(kubectl get pods --namespace=${ns} -l app=<app-name> -o jsonpath="{.items[0].metadata.name}") --namespace=${ns} -- df -h | awk '/^\/dev/{print $2}')

  # write the data to the CSV file
  echo "${ns},\"${storage}\"" >> "${file_location}${file_name}"
done
