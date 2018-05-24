#/bin/bash
#generate certificate for example:
#mkdir -p /usr/local/kubedev/git/certs
#cd  /usr/local/kubedev/git/certs
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout dashboard.key -out dashboard.crt -subj "/CN=session03-exercise-03.com"
echo installing secret see comments for generate tls
kubectl create secret generic kubernetes-dashboard-certs --from-file=/usr/local/kubedev/git/certs -n kube-system

echo installing dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
