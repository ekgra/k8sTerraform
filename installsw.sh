#! /bin/bash
sudo apt-get update

# disable swap 
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 1. install the container run time (containerd)
#    https://github.com/containerd/containerd/blob/main/docs/getting-started.md
#   1.1 install containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.1/containerd-1.7.1-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.1-linux-amd64.tar.gz

# get the continerd unit file
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /etc/systemd/system/containerd.service

# start the containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

#   1.2 install runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

#   1.3 install cni plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz
mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.3.0.tgz

#   1.4 install crictl 
#       https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md
VERSION="v1.27.0" # check latest version in /releases page
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

#   1.5 create configuration to enable crictl to read the containerd socket file 
#       unix:///var/run/containerd/containerd.sock
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF

# 2. Prerequisites - Forwarding IPv4 and letting iptables see bridged traffic
#    https://kubernetes.io/docs/setup/production-environment/container-runtimes/#forwarding-ipv4-and-letting-iptables-see-bridged-traffic
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


# 3. Install kuberadm, kubectl and kubelet
#   3.1 Update the apt package index and install packages needed to use the Kubernetes apt repository
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

#   3.2 Download the Google Cloud public signing key
sudo mkdir /etc/apt/keyrings/
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

#   3.3 Add the Kubernetes apt repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#   3.4 Update apt package index, install kubelet, kubeadm and kubectl, and pin their version
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

touch /home/ubuntu/fini