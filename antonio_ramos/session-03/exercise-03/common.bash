#!/bin/bash

# 
# IP RANGES
#
export NODES_INTERNAL_NET=172.31.16.0/20
export SERVICE_CLUSTERIP_NET=10.200.0.0/24
export PODS_NET=10.32.0.0/16

# 
# IP ADDRESSES
# 

export CONTROLLER0_PUBLIC_IP=34.229.150.244
export CONTROLLER0_PRIVATE_IP=172.31.47.5

export CONTROLLER1_PUBLIC_IP=34.224.32.40
export CONTROLLER1_PRIVATE_IP=172.31.47.172


export WORKER0_PUBLIC_IP=52.207.241.102
export WORKER0_PRIVATE_IP=172.31.32.160

export WORKER1_PUBLIC_IP=54.227.187.157
export WORKER1_PRIVATE_IP=172.31.41.166

export KUBE_APISERVER_SERVICE_IP=10.200.0.1
export KUBE_DNS_SERVICE_IP=10.200.0.33

export CLUSTER_DOMAIN=aramoscluster.local

#
# DIR
#

export KUBERNETES_DIR=/etc/kubernetes
export KUBERNETES_CERT_DIR=$KUBERNETES_DIR/pki
export KUBERNETES_KUBECONFIG_DIR=$KUBERNETES_DIR/kubeconfig
export KUBERNETES_BIN_DIR=/usr/local/bin
export ETCD_CONF_DIR=/etc/etcd
export ETCD_CERT_DIR=$ETCD_CONF_DIR/pki
export ETCD_BIN_DIR=/usr/local/bin

# 
# CREDENTIALS
#

## Cluster authority
export KUBERNETES_CA_KEY_PATH=$KUBERNETES_CERT_DIR/ca.key
export KUBERNETES_CA_CERT_PATH=$KUBERNETES_CERT_DIR/ca.crt

## etcd
export ETCD_SERVER_KEY_PATH=$ETCD_CERT_DIR/etcd_server.key
export ETCD_SERVER_CERT_PATH=$ETCD_CERT_DIR/etcd_server.crt
export ETCD_CLIENT_KEY_PATH=$ETCD_CERT_DIR/etcd_client.key
export ETCD_CLIENT_CERT_PATH=$ETCD_CERT_DIR/etcd_client.crt

## kube-apiserver
export KUBE_APISERVER_KEY_PATH=$KUBERNETES_CERT_DIR/kube-apiserver.key
export KUBE_APISERVER_CERT_PATH=$KUBERNETES_CERT_DIR/kube-apiserver.crt

## kube-controller-manager
export KUBE_CONTROLLER_MANAGER_KEY_PATH=$KUBERNETES_CERT_DIR/kube-controller-manager.key
export KUBE_CONTROLLER_MANAGER_CERT_PATH=$KUBERNETES_CERT_DIR/kube-controller-manager.crt
export KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH=$KUBERNETES_KUBECONFIG_DIR/kube-controller-manager.kubeconfig

## kube-scheduler
export KUBE_SCHEDULER_KEY_PATH=$KUBERNETES_CERT_DIR/kube-scheduler.key
export KUBE_SCHEDULER_CERT_PATH=$KUBERNETES_CERT_DIR/kube-scheduler.crt
export KUBE_SCHEDULER_KUBECONFIG_PATH=$KUBERNETES_KUBECONFIG_DIR/kube-scheduler.kubeconfig

## service account generation
export SERVICE_ACCOUNT_GEN_KEY_PATH=$KUBERNETES_CERT_DIR/service-account-gen.key
export SERVICE_ACCOUNT_GEN_CERT_PATH=$KUBERNETES_CERT_DIR/service-account-gen.crt

## kubelet
export KUBELET_KEY_PATH=$KUBERNETES_CERT_DIR/kubelet.key
export KUBELET_CERT_PATH=$KUBERNETES_CERT_DIR/kubelet.crt
export KUBELET_KUBECONFIG_PATH=$KUBERNETES_KUBECONFIG_DIR/kubelet.kubeconfig

## kube-proxy
export KUBE_PROXY_KEY_PATH=$KUBERNETES_CERT_DIR/kube-proxy.key
export KUBE_PROXY_CERT_PATH=$KUBERNETES_CERT_DIR/kube-proxy.crt
export KUBE_PROXY_KUBECONFIG_PATH=$KUBERNETES_KUBECONFIG_DIR/kube-proxy.kubeconfig

## admin user
export ADMIN_CERT_DIR=~/.certs/kubernetes/admin
export ADMIN_CERT_PATH=$ADMIN_CERT_DIR/admin.crt
export ADMIN_KEY_PATH=$ADMIN_CERT_DIR/admin.key
export ADMIN_CLUSTER_CA_PATH=$ADMIN_CERT_DIR/ca.crt

## regular user
export USER_NAME=aramos
export USER_CERT_DIR=~/.certs/kubernetes/$USER_NAME
export USER_CERT_PATH=$USER_CERT_DIR/$USER_NAME.crt
export USER_KEY_PATH=$USER_CERT_DIR/$USER_NAME.key
export USER_CLUSTER_CA_PATH=$USER_CERT_DIR/ca.crt

#
# ASSETS TO DOWNLOAD
#

export CONTAINERD_URL=https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.0.linux-amd64.tar.gz
## Kubernetes components
export KUBERNETES_VERSION=1.10.2
export KUBERNETES_BASE_URL=https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64
export KUBE_APISERVER_URL=$KUBERNETES_BASE_URL/kube-apiserver
export KUBE_CONTROLLER_MANAGER_URL=$KUBERNETES_BASE_URL/kube-controller-manager
export KUBECTL_URL=$KUBERNETES_BASE_URL/kubectl
export KUBE_SCHEDULER_URL=$KUBERNETES_BASE_URL/kube-scheduler
export KUBELET_URL=$KUBERNETES_BASE_URL/kubelet
export KUBE_PROXY_URL=$KUBERNETES_BASE_URL/kube-proxy

## Etcd
export ETCD_VERSION=3.3.5
export ETCD_TARBALL_NAME=etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
export ETCD_TARBALL_URL=https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/$ETCD_TARBALL_NAME

## CNI
export CNI_VERSION=0.6.0
export CNI_TARBALL_NAME=cni-plugins-amd64-v${CNI_VERSION}.tgz
export CNI_TARBALL_URL=https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/$CNI_TARBALL_NAME

## helm
export HELM_BASE_URL=https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz

#
# SYSTEMD 
#

export SYSTEMD_SERVICE_DIR=/etc/systemd/system

export ETCD_SYSTEMD_SERVICE_NAME=etcd.service
export ETCD_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$ETCD_SYSTEMD_SERVICE_NAME

export KUBE_APISERVER_SYSTEMD_SERVICE_NAME=kube-apiserver.service
export KUBE_APISERVER_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$KUBE_APISERVER_SYSTEMD_SERVICE_NAME

export KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_NAME=kube-controller-manager.service
export KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_NAME

export KUBE_SCHEDULER_SYSTEMD_SERVICE_NAME=kube-scheduler.service
export KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$KUBE_SCHEDULER_SYSTEMD_SERVICE_NAME

export KUBELET_SYSTEMD_SERVICE_NAME=kubelet.service
export KUBELET_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$KUBELET_SYSTEMD_SERVICE_NAME

export KUBE_PROXY_SYSTEMD_SERVICE_NAME=kube-proxy.service
export KUBE_PROXY_SYSTEMD_SERVICE_PATH=$SYSTEMD_SERVICE_DIR/$KUBE_PROXY_SYSTEMD_SERVICE_NAME

