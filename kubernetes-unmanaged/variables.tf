# Define a variable for the default region where the infrastructure will be provisioned
variable "k8-region" {
  type        = string
  description = "Default Region"
}

# Define a variable for the CIDR block of the main VPC
variable "k8-vpc-cidr" {
  type        = string
  description = "CIDR block of main VPC"
}

# Define a variable for the CIDR block of the first subnet
variable "k8-subnet-cidr" {
  type        = string
  description = "CIDR block of the first subnet"
}

# Define a variable for the external IP range
variable "external_ip" {
  type        = string
  description = "Our external IP"
  default     = "0.0.0.0/0" # Default value set to allow all IPs
}

# Define a variable for the instance type used for both Kubernetes nodes and master
variable "instance_type" {
  type        = string
  description = "Instance type for Kubernetes nodes and master"
  default     = "t2.micro" # Default instance type set to t2.micro
}

# Define a variable for the number of Kubernetes worker nodes
variable "workers-count" {
  type        = number
  default     = 2
  description = "Number of Kubernetes worker nodes"
}
