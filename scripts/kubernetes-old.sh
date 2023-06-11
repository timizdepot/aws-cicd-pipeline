#!/bin/bash
# install docker runtime
# open link, create and run this bash script
sudo apt update && sudo apt full-upgrade -y
# disable swap 
swapoff -a
# install docker runtime
sudo apt install docker.io -y

# start and enable services
sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl enable containerd


# install kubectl, kubelet, and kubeadm
# update the apt package index and install packages 
# needed to use the Kubernetes apt repository:
# sudo apt-get update && sudo apt full-upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl

# download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm 
# and kubectl, and pin their version:
# apt-cache madison kubeadm (to get the available versions)
sudo apt-get update && sudo apt full-upgrade -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# verify it has been installed
# kubectl version --client -o json && kubeadm version -o json
# systemctl status kubelet

# enable kernel module
modprobe overlay
modprobe br_netfilter

# add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# reload sysctl
sudo sysctl --system

# # check if the br_netfilter module is loaded
# lsmod | grep br_netfilter

# new - pull the config images
# kubeadm config images pull
# list the pulled images
# kubeadm config images list

# if cri error, run:
# sudo rm /etc/containerd/config.toml
# sudo systemctl restart containerd

# check available kubeadm versions (when manually executing)
# apt-cache madison kubeadm
# Install version 1.21.0 for all components
sudo apt-get install -y kubelet=1.25.6-00 kubeadm=1.25.6-00 kubectl=1.25.6-00
# apt-mark hold prevents package from being automatically upgraded or removed
sudo apt-mark hold kubelet kubeadm kubectl
# enable kubelet service
sudo systemctl enable kubelet

# check status on kubelet kubeadm kubectl
# service kubelet status && kubeadm && kubectl
# check the log to see if the userdata ran
# cat /var/log/cloud-init-output.log tail 50