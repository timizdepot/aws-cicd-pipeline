#!/bin/bash
# Install and configure prerequisites
sudo swapoff -a
# Install Containerd
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system
# install containerd
sudo apt update
sudo apt install -y containerd
# generate a containerd config file 
sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
# update the systemgroup 
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

# Install packages needed to use the Kubernetes apt repository
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
# Download the Google Cloud public signing key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# Add the Kubernetes apt repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Install kubelet, kubeadm & kubectl, and pin their versions
sudo apt-get update
# check available kubeadm versions (when manually executing)
# apt-cache madison kubeadm
# Install version 1.21.0 for all components
sudo apt-get install -y kubelet=1.25.6-00 kubeadm=1.25.6-00 kubectl=1.25.6-00
# apt-mark hold prevents package from being automatically upgraded or removed
sudo apt-mark hold kubelet kubeadm kubectl
# check status on kubelet kubeadm kubectl
# service kubelet status && kubeadm && kubectl

# check the log to see if the userdata ran
# cat /var/log/cloud-init-output.log tail 50