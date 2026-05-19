#!/bin/bash

echo "[GÖREV 1] Swap alanını kapat"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[GÖREV 2] Gerekli Kernel modüllerini yükle"
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "[GÖREV 3] Ağ (Network) ayarlarını yapılandır"
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[GÖREV 4] Containerd kurulumu ve yapılandırması"
apt-get update -qq >/dev/null
apt-get install -y -qq apt-transport-https ca-certificates curl containerd >/dev/null
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

echo "[GÖREV 5] Kubeadm, Kubelet ve Kubectl (v1.29) kurulumu"
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -qq >/dev/null
apt-get install -y -qq kubelet kubeadm kubectl >/dev/null
# Güncellemelerde k8s versiyonunun bozulmaması için versiyonları sabitliyoruz
apt-mark hold kubelet kubeadm kubectl
