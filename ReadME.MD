FOCUS AREAS

Azure Kubernetes Service (AKS) is a managed Kubernetes service provided by Microsoft Azure. To optimize costs when using AKS, consider focusing on the following areas:

1. Right-sizing nodes and node pools: Choose the appropriate VM size and number of nodes for your workloads to balance performance and cost.
2. Use spot instances: Leverage Azure Spot VMs for fault-tolerant workloads, as they can be significantly cheaper than regular instances.
3. Autoscaling: Implement AKS cluster autoscaling and pod autoscaling to adjust the number of nodes and pods based on workload requirements automatically.
4. Optimize container resource requests and limits: Set appropriate CPU and memory requests and limits for your containers to avoid over-allocating resources or causing performance issues.
5. Use Azure Reserved Instances: Purchase Azure Reserved Instances for long-term workloads to save money compared to pay-as-you-go pricing.
6. Utilize multiple node pools: Use different node pools for different types of workloads, allowing you to optimize costs by choosing the right VM size and scaling settings for each workload.
7. Optimize storage: Evaluate your storage requirements and select the appropriate storage class, provisioning, and management options to minimize costs. Use Azure Blob Storage or Azure Files for stateful applications, and consider lifecycle policies to automatically delete unused data.
8. Monitor and analyze resource usage: Use Azure Monitor and other monitoring tools to track resource usage, identify areas for improvement, and make informed decisions about cost optimization.
9. Implement workload-specific optimizations: Optimize your application code, container images, and deployment strategies to minimize resource usage and cost.
10. Network optimization: Optimize your network traffic by using Azure Load Balancer, Application Gateway, or other services to route traffic efficiently and reduce data transfer costs.
11. Take advantage of Azure Cost Management: Utilize Azure Cost Management tools to gain insights into your AKS infrastructure costs and identify cost-saving opportunities.

Storage supported by AKS:

Azure Kubernetes Service (AKS) supports a variety of volume types for use with pods. These volume types provide different storage options depending on your requirements. Here are some of the most common volume types supported in AKS:

- Azure Disk Storage: Azure Disks are block-level storage volumes that can be used with AKS. You can use Azure Managed Disks, which come in various performance tiers like Standard HDD, Standard SSD, Premium SSD, and Ultra Disk. To use Azure Disks with AKS, you can leverage the azureDisk volume type in your Kubernetes manifests.
- Azure Files: Azure Files is a managed file storage service that allows you to create and use SMB file shares. It can be used as a shared storage option for your AKS workloads using the azureFile volume type.
- EmptyDir: emptyDir is a temporary volume that can be used by a container within a pod. The data in an emptyDir volume is ephemeral, meaning it only exists for the lifetime of the pod and is deleted when the pod is terminated.
- ConfigMap: configMap volumes allow you to store non-confidential configuration data in key-value pairs and mount them as files within a container. ConfigMaps can be used for application configuration and other purposes that don't require secure storage.
- Secret: secret volumes are used to store sensitive information, like passwords or API keys, and securely expose them to containers within a pod. The data stored in a secret volume is base64-encoded but not encrypted.
- PersistentVolume and PersistentVolumeClaim: persistentVolume (PV) and persistentVolumeClaim (PVC) provide a way to request and allocate storage resources in a Kubernetes cluster. PVs represent physical storage resources, while PVCs request a specific amount of storage from those resources. AKS can use Azure Disk Storage or Azure Files as the underlying storage provider for PVs.
- HostPath: The hostPath volume type mounts a file or directory from the host node's filesystem into a container. This option should be used with caution, as it can lead to data loss and security risks if not managed correctly.
- NFS: You can also use Network File System (NFS) volumes in AKS if you have an existing NFS server or use a third-party service that provides NFS storage. To use NFS volumes, you will need to configure the nfs volume type in your Kubernetes manifests.

These are some of the common volume types supported by AKS for use with pods. Depending on your specific storage needs, you can choose the appropriate volume type for your workloads.

Terminology

- Namespaces: Namespaces in Azure Kubernetes Service (AKS) serve the same purpose as in any other Kubernetes environment. A namespace is a logical construct within a Kubernetes cluster used for organizing, isolating, and managing resources. Namespaces make it easier to manage different projects, teams, and environments within the same cluster.
- Resource Quotas: Resource quotas in Azure Kubernetes Service (AKS) and other Kubernetes environments are used to control the consumption of resources within a specific namespace. They help prevent one project or team from consuming all available resources in the cluster and ensure fair resource allocation among different namespaces.

```apiVersion: v1
kind: ResourceQuota
metadata:
  name: my-resource-quota
spec:
  hard:
    cpu: "4"
    memory: 8Gi
    pods: "10"
```
In this example, the resource quota limits the total CPU requests to 4 cores, the total memory requests to 8 GiB, and the maximum number of pods in the namespace to 10.

By applying resource quotas in AKS, you can manage resource allocation effectively and ensure that the cluster resources are used efficiently and fairly among different teams, projects, or environments.

- CPU Limits/Used:

In Azure Kubernetes Service (AKS) and other Kubernetes environments, you can set limits and requests on both CPU and memory usage for your containers. By setting these limits and requests, you can control the allocation of CPU and memory resources to containers, ensure fair resource distribution, and avoid resource contention.

Here's how CPU and memory limits and requests work in AKS:

CPU Requests: The minimum amount of CPU resources guaranteed to a container. CPU requests are specified in millicores (1/1000 of a core), such as 100m or 0.1.
CPU Limits: The maximum amount of CPU resources that a container can use. If a container's CPU usage exceeds the limit, it may be throttled or have its CPU cycles reduced. Like CPU requests, CPU limits are specified in millicores.
Memory Requests: The minimum amount of memory resources guaranteed to a container. Memory requests are specified in bytes or with common suffixes like 'Mi' (mebibytes) or 'Gi' (gibibytes), such as 64Mi or 2Gi.
Memory Limits: The maximum amount of memory resources that a container can use. If a container's memory usage exceeds the limit, it may be terminated or have its processes killed by the operating system. Memory limits are specified in the same way as memory requests.

To set CPU and memory requests and limits in AKS, you need to define them in the container spec within a Kubernetes manifest file (e.g., a Deployment or Pod resource). Here's an example of how to set CPU and memory requests and limits for a container:

```apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
```
In this example, the container is guaranteed a minimum of 100 millicores of CPU (0.1 core) and 128 MiB of memory. It can use up to 500 millicores (0.5 core) of CPU before being throttled and up to 256 MiB of memory before being terminated or having its processes killed.

It's important to set appropriate CPU and memory requests and limits for your containers in AKS to ensure efficient resource utilization and prevent performance issues caused by resource contention or over-allocation.

Determining Pod Size

- When determining the pod size, you'll primarily be focusing on setting the right CPU and memory requests and limits for each container within the pod. Here are some effective ways to define the appropriate pod size:

- Analyze application requirements: Understand your application's resource requirements based on its architecture, workload, and performance needs. Consider the minimum and maximum resources required for the application to function correctly, and determine the appropriate CPU and memory settings.

- Monitor historical usage: Use monitoring tools such as Prometheus or Kubernetes Metrics Server, along with visualization tools like Grafana, to analyze historical resource usage data. This information can help you identify patterns in resource consumption and adjust the pod size accordingly.

- Perform load testing: Run load tests on your application to simulate real-world traffic and identify how your application behaves under different levels of load. Use the results to fine-tune the pod size based on the application's performance and scalability requirements.

- Use Vertical Pod Autoscaler (VPA): Vertical Pod Autoscaler can automatically adjust the CPU and memory requests and limits for your containers based on historical resource usage data. VPA can be a helpful tool for optimizing pod sizes over time, but it should be used cautiously and in conjunction with manual analysis.

- Start with conservative settings: When initially defining pod sizes, it's better to be conservative and allocate slightly more resources than you think are needed. You can then monitor resource usage and adjust the pod size as needed based on real-world data.

- Optimize application code: Make sure that your application code is optimized for performance and efficient resource usage. Optimizing the application can help you reduce resource requirements and make it easier to determine the right pod size.

- Test and iterate: Continuously test your application's performance and resource consumption as you make changes to the pod size. Be prepared to iterate and adjust the settings as needed based on feedback and real-world data.

Always monitor and analyze your application's performance and resource usage to make informed decisions about your pod sizes.


Common optimization techniques:


To optimize costs in Azure Kubernetes Service (AKS), you need to efficiently manage resources and take advantage of various Azure features and best practices. Here are some cost optimization techniques for AKS:

- Right-size your nodes: Choose the appropriate VM size for your node pool based on your workload's resource requirements. Monitor your workloads and adjust the VM size as needed to avoid over-provisioning or under-provisioning resources.
- Use multiple node pools: Create different node pools with varying VM sizes and types to accommodate different workloads. This allows you to allocate resources more efficiently and reduce costs.
- Scale your cluster: Use the AKS cluster autoscaler to automatically scale the number of nodes in a node pool based on demand. This ensures that you have the right amount of resources to handle your workloads, without over-provisioning or under-provisioning resources.
- Implement pod disruption budgets: Pod disruption budgets (PDBs) can help ensure that a minimum number of replicas are always available for your applications, allowing for more efficient resource allocation.
- Use spot instances: Leverage Azure Spot VMs for your AKS node pools to take advantage of unused capacity at a discounted price. Be aware that spot instances can be preempted, so ensure your workloads can tolerate interruptions.
- Set resource requests and limits: Properly configure resource requests and limits for your containers to avoid resource contention and over-allocation. This helps ensure efficient resource usage and better cost management.
- Implement resource quotas: Use resource quotas to limit the consumption of resources within a specific namespace. This helps prevent one project or team from consuming all available resources and ensures fair resource allocation.
- Optimize storage usage: Choose the right storage classes and sizes for your Persistent Volumes (PVs) and Persistent Volume Claims (PVCs). Delete unused PVs and PVCs to free up storage and reduce costs.
- Monitor and analyze: Use monitoring tools like Prometheus, Kubernetes Metrics Server, and Azure Monitor to track resource usage and identify areas for cost optimization.
- Utilize Azure Reserved Instances: Purchase Azure Reserved Instances for your AKS node pools if you have long-term, predictable workloads. This can help you save money by committing to a one or three-year term.
- Optimize application code: Ensure that your applications are optimized for performance and efficient resource usage. This can help reduce overall resource requirements and associated costs.

By applying these cost optimization techniques in AKS, you can achieve better resource allocation, improved performance, and reduced costs. Continuously monitor and analyze your resource usage and make adjustments as needed to ensure the most efficient and cost-effective use of your AKS cluster.
