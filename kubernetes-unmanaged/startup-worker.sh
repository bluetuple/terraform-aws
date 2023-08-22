#!/bin/bash

# Load necessary kernel modules for containerd
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure kernel networking requirements for Kubernetes
cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# Update package information and install containerd
sudo apt-get update && sudo apt-get install -y containerd

# Generate and set containerd configuration
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd with the new configuration
sudo systemctl restart containerd

# Disable swap to meet Kubernetes requirements
sudo swapoff -a
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Add Kubernetes apt repository and GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Update package information and install specific Kubernetes components
sudo apt-get update && sudo apt-get install -y kubelet=1.28.0-00 kubeadm=1.28.0-00 kubectl=1.28.0-00

# Prevent automatic updates for Kubernetes components
sudo apt-mark hold kubelet kubeadm kubectl


