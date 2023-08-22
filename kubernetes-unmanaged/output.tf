# Define an output to display the public IP address of the Kubernetes master node
output "Kubernetes-Master-Node-Public-IP" {
  value = aws_instance.k8-master.public_ip # Retrieve the public IP of the Kubernetes master node
}

# Define an output to display a map of worker node IDs to their public IP addresses
output "Kubernetes-Worker-nodes-Public-IP" {
  value = {
    for instance in aws_instance.k8-node : # Loop through each worker node instance
    instance.id => instance.public_ip      # Create a map entry: instance ID => public IP
  }
}
