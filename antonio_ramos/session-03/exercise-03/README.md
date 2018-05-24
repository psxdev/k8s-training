# Exercise II

## Kubernetes Cluster installation

We will create a kubernetes clusters with 2 controllers and 2 worker, really is a best practice to use 3 etcd nodes but we will use only 2 in the controllers.

It is not finished and it is not user friendly, many things are done manually in the nodes no time to left all clean and automatized from client so it can't be launch directly


## step 1 generate auth directly in controller0 we will use that to generate certifacates
01-cluster-auth.bash
## step 2 install etcd directly in controller0
02-etcd-controler0.bash
## step 3 install etcd directly in controller1
03-etcd-controler1.bash
## step 4 install kube-apiserver directly in controller0
04-kube-apiserver-controller0.bash
## step 5 install kube-apiserver directly in controller1
05-kube-apiserver-controller1.bash
## step 6 generat admin config. Included gpg file
06-admin-kubeconfig.bash
## step 7 install kube-controller-manager directly in controller0
07-kube-controller-manager-controller0.bash
## step 8 install kube-controller-manager directly in controller1
08-kube-controller-manager-controller1.bash
## step 9 update kube-apiserver directly in controller1
09-update-kube-apiserver-controller0.bash
## step 10 udpate kube-apiserver directly in controller1
10-update-kube-apiserver-controller1.bash
## step 11 install kube-scheduler directly in controller0
11-kube-scheduller-controller0.bash
## step 12 install kube-scheduler directly in controller0
12-kube-scheduller-controller1.bash
## step 13 install kubelet directly in worker0 
First i try with containerd and i get some version api mismatch messages, i found that the problem was fixed with other version different than repository
```
cat << EOF | sudo tee /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/sbin/runc"
      runtime_root = ""
    [plugins.cri.containerd.untrusted_workload_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runsc"
      runtime_root = "/run/containerd/runsc"
EOF
wget -q https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.0.linux-amd64.tar.gz -P /tmp
sudo tar -xvf cri-containerd-1.1.0.linux-amd64.tar.gz -C /
```
and config for kubelet
```
cat << EOF | sudo tee "$KUBELET_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kubelet

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kubelet \\
  --kubeconfig=${KUBELET_KUBECONFIG_PATH} \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --network-plugin=cni \\
  --cni-conf-dir=/etc/cni/net.d \\
  --cni-bin-dir=/opt/cni/bin \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
finally i changed to docker after some issues to see if it was problem with containerd

  
13-kube-worker0.bash
## step 14 install kubelet directly in worker1
14-kube-worker1.bash

## step 17 udpate kube-apiserver directly in controller0 
17-update-kube-apiserver-controller0.bash
## step 18 upadte kube-apiserver directly in controller1 
18-update-kube-apiserver-controller1.bash
## step 19 calico install from controller0
I got running using tls certificate with custom yaml mycalico.yaml. Problem was without populating certs in it doesn't boot pods
19-calico-controller0.bash
## step 20 kube-proxy in worker0
20-kube-proxy-worker0.bash
## step 21 kube-proxy in worker1
21-kube-proxy-worker0.bash
## step 22 helm
i am in trouble here tiller pod doesn't boot investigating issue
```
kubectl get pods -n kube-system
NAME                             READY     STATUS              RESTARTS   AGE
calico-node-lshsr                2/2       Running             0          11h
calico-node-vpfds                2/2       Running             0          11h
calico-policy-controller-h4tpj   1/1       Running             0          11h
kube-dns-7cc76cdf5f-pxjqb        0/3       ContainerCreating   0          10h
tiller-deploy-6cc489b4fb-sq2hs   0/1       ContainerCreating   0          10h
```
22-helm.bash

Daniel Dominguez help me to depure the error, the problem was mycalico was using a different path for configuration and it was populating all config files in workers at /etc/kubernetes/cni/net.d and it was different than expected by kubelet /etc/cni/net.d, after fix that in fresh yaml from calico all was fine an tiller is on!!

```
kubectl get pods -n kube-system 
NAME                                       READY     STATUS    RESTARTS   AGE
calico-kube-controllers-5b85d756c6-l7ljz   1/1       Running   0          2m
calico-node-6x4nr                          2/2       Running   0          2m
calico-node-m2pl2                          2/2       Running   0          2m
kube-dns-7cc76cdf5f-pxjqb                  2/3       Running   1          11h
tiller-deploy-8588b5d864-xhwzj             1/1       Running   0          23m
```
Finally figured out problem security group on AWS, added additional ports for dns probe and kubelet inconming traffic

## step 23 nfs
23-nfs.bash
## step 24 trefick ingress
24-traefick.bash
## step 25 dashboard
25-dashboard.bash

and finally

```
kubectl get pods -n kube-system
NAME                                       READY     STATUS    RESTARTS   AGE
calico-kube-controllers-5b85d756c6-l7ljz   1/1       Running   2          6h
calico-node-6x4nr                          2/2       Running   0          6h
calico-node-m2pl2                          2/2       Running   2          6h
kube-dns-7cc76cdf5f-8mk2p                  3/3       Running   23         1h
kubernetes-dashboard-7d5dcdb6d9-hgs5f      1/1       Running   0          5m
nfs-provisioner-nfs-server-provisioner-0   1/1       Running   0          55m
tiller-deploy-8588b5d864-xhwzj             1/1       Running   0          6h
traefik-ingress-6577bd8fff-kkrq2           1/1       Running   0          35m
```






