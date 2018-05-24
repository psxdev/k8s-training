#!/bin/bash

source ./common.bash


kubectl apply -f calico.yaml

# The above will not work because of the non-privileged container, so we need 
# to reconfigure kubelet and kube-apiserver. Execute the following on each worker
## Create systemd service
cat << EOF | sudo tee "$KUBELET_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kubelet

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kubelet \\
  --kubeconfig=${KUBELET_KUBECONFIG_PATH} \\
  --container-runtime=docker \\
  --network-plugin=cni \\
  --cni-conf-dir=/etc/cni/net.d \\
  --cni-bin-dir=/opt/cni/bin \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --v=2 \\
  --allow-privileged=true
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable kubelet.service
systemctl restart kubelet.service

systemctl status kubelet.service

#
#  Execute the following in the controller node
#

cat << EOF | sudo tee "$KUBE_APISERVER_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-apiserver

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-apiserver \\
  --tls-cert-file=${KUBE_APISERVER_CERT_PATH} \\
  --tls-private-key-file=${KUBE_APISERVER_KEY_PATH} \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --etcd-cafile=${KUBERNETES_CA_CERT_PATH} \\
  --etcd-certfile=${ETCD_CLIENT_CERT_PATH} \\
  --etcd-keyfile=${ETCD_CLIENT_KEY_PATH} \\
  --etcd-servers=https://${CONTROLLER0_PRIVATE_IP}:2379,https://${CONTROLLER1_PRIVATE_IP}:2379 \\
  --service-cluster-ip-range=${SERVICE_CLUSTERIP_NET} \\
  --authorization-mode=Node,RBAC \\
  --v=2 \\
  --service-account-key-file=${SERVICE_ACCOUNT_GEN_CERT_PATH} \\
  --allow-privileged=true
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart kube-apiserver.service
systemctl restart kube-controller-manager.service
systemctl restart kube-scheduler.service

#
# Now try deploying again
#
kubectl apply -f rbac.yaml
kubectl apply -f calico.yaml
