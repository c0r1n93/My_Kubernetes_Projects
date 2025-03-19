#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

# Disable Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Add Kernel Parameters
echo "---------------- Load the required kernel modules -----------------------"
sleep 5
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter


echo "----------------  Configure the critical kernel parameters for Kubernetes  ------------------"
sleep 5
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo "---------------------  Reload the changes  --------------------------------"
sudo sysctl --system


# Install Containerd Runtime
echo "-------------------------  Install containerd and its dependencies  -----------------------------------"
sleep 5
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

echo "-------------------------  Enable the Docker repository  ------------------------------------"
sleep
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "-------------------------  Update the package list and install containerd  ------------------------"
sleep 5
sudo apt update
sudo apt install -y containerd.io

echo "------------------------  Configure containerd to start using systemd as cgroup  ----------------------"
sleep 3
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo "------------------------  Restart and enable the containerd service  -------------------------------"
sleep 3
sudo systemctl restart containerd
sudo systemctl enable containerd


# Add Apt Repository for Kubernetes
echo "--------------------------  Add the Kubernetes repositories  -----------------------------------"
sleep 3
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# Install Kubectl, Kubeadm, and Kubelet
echo "-----------------------------  Install Kubectl, Kubeadm, and Kubelet  -----------------------"
sleep 3
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

