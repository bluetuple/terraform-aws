# Create an AWS SSH key pair for authentication
resource "aws_key_pair" "ssh_key" {
  key_name   = "kubernetes-key"          # Key pair name
  public_key = file("~/.ssh/id_rsa.pub") # Use the public key from the local SSH keypair
}

# Provision the Kubernetes master node
resource "aws_instance" "k8-master" {
  ami                         = "ami-020b33a9e86370158"              # Ubuntu 20.04 LTS AMI ID
  instance_type               = var.instance_type                    # Instance type specified in variables
  key_name                    = aws_key_pair.ssh_key.key_name        # Use the AWS SSH key
  associate_public_ip_address = true                                 # Associate a public IP
  vpc_security_group_ids      = [aws_security_group.k8cluster-sg.id] # Use the Kubernetes security group
  subnet_id                   = aws_subnet.subnet1.id                # Use the specified subnet

  # Use a startup script for configuring the master node
  user_data = file("startup-master.sh")

  tags = {
    Name = "kubernetes-master"
  }

  depends_on = [aws_main_route_table_association.kubernetes-set-rt-to-vpc]
}

# Provision Kubernetes worker nodes
resource "aws_instance" "k8-node" {
  count                       = var.workers-count                    # Create the specified number of worker nodes
  ami                         = "ami-020b33a9e86370158"              # Ubuntu 20.04 LTS AMI ID
  instance_type               = var.instance_type                    # Instance type specified in variables
  key_name                    = aws_key_pair.ssh_key.key_name        # Use the AWS SSH key
  associate_public_ip_address = true                                 # Associate a public IP
  vpc_security_group_ids      = [aws_security_group.k8cluster-sg.id] # Use the Kubernetes security group
  subnet_id                   = aws_subnet.subnet1.id                # Use the specified subnet

  # Use a startup script for configuring the worker nodes
  user_data = file("startup-worker.sh")

  tags = {
    Name = join("-", ["kubernetes-node", count.index + 1]) # Create unique names for each node
  }
  # ensure required network settings are deployed beforehand
  depends_on = [aws_main_route_table_association.kubernetes-set-rt-to-vpc]
}
