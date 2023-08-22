# Create the main public VPC for Kubernetes
resource "aws_vpc" "vpc_kubernetes" {
  cidr_block           = var.k8-vpc-cidr # Define the IP address range for the VPC
  enable_dns_support   = true            # Enable DNS support for the VPC
  enable_dns_hostnames = true            # Enable DNS hostnames for the VPC

  tags = {
    Name = "kubernetes-vpc" # Assign a name tag to the VPC
  }
}

# Create an Internet Gateway for VPC connectivity
resource "aws_internet_gateway" "igw-kubernetes" {
  vpc_id = aws_vpc.vpc_kubernetes.id # Attach the Internet Gateway to the Kubernetes VPC
  tags = {
    Name = "kubernetes-vpc-igw" # Assign a name tag to the Internet Gateway
  }
}

# Get a list of available Availability Zones in the VPC region
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a subnet in the VPC's first Availability Zone
resource "aws_subnet" "subnet1" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0) # Use the first AZ in the region
  vpc_id            = aws_vpc.vpc_kubernetes.id                         # Attach to the Kubernetes VPC
  cidr_block        = var.k8-subnet-cidr                                # Define the subnet's IP range
}

# Create a route table for internet access
resource "aws_route_table" "kubernetes-internet-route" {
  vpc_id = aws_vpc.vpc_kubernetes.id # Associate the route table with the Kubernetes VPC

  route {
    cidr_block = "0.0.0.0/0"                            # Route all traffic to the internet
    gateway_id = aws_internet_gateway.igw-kubernetes.id # Use the Internet Gateway for the route
  }

  lifecycle {
    ignore_changes = all # Ignore changes in the route table's lifecycle
  }

  tags = {
    Name = "KubernetesRouteTable" # Assign a name tag to the route table
  }
}

# Associate the route table with the VPC's main route table
resource "aws_main_route_table_association" "kubernetes-set-rt-to-vpc" {
  vpc_id         = aws_vpc.vpc_kubernetes.id                    # Associate with the Kubernetes VPC
  route_table_id = aws_route_table.kubernetes-internet-route.id # Use the previously created route table
}
