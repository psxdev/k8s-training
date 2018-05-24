#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-proxy
#
# At the end of this script you will have running Kube Controller Manager
#

helm install stable/nfs-server-provisioner --name nfs-provisioner --namespace kube-system --set storageClass.defaultClass=true

# In each worker node

sudo apt install nfs-common -y

