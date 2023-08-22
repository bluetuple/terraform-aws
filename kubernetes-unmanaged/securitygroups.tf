# Create an AWS security group for the Kubernetes cluster
resource "aws_security_group" "k8cluster-sg" {
  name        = "k8cluster-sg"
  description = "Allows incoming SSH and outgoing to all ports"
  vpc_id      = aws_vpc.vpc_kubernetes.id

  # Allow all outgoing traffic to the internet
  egress {
    description = "Allows all ports to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming ICMP traffic from the specified CIDR block
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.k8-vpc-cidr]
  }

  # Allow incoming TCP traffic within the specified CIDR block
  ingress {
    description = "TCP internal"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.k8-vpc-cidr ]
  }

  # Allow incoming SSH traffic from the specified external IP address
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
    # Uncomment the line below to allow SSH from any IP (not recommended for security)
    # cidr_blocks = ["0.0.0.0/0"]
  }
}
