
## Create cert dirs
mkdir -p ~/.certs/kubernetes/sandbox/

## Private keys
openssl genrsa -out ~/.certs/kubernetes/sandbox/jsalmeron.key 2048
openssl genrsa -out ~/.certs/kubernetes/sandbox/juan.key 2048
openssl genrsa -out ~/.certs/kubernetes/sandbox/dbarranco.key 2048

## Certificate sign requests
openssl req -new -key ~/.certs/kubernetes/sandbox/jsalmeron.key -out /tmp/jsalmeron.csr -subj "/CN=jsalmeron/O=tech-lead/O=dev"
openssl req -new -key ~/.certs/kubernetes/sandbox/juan.key -out /tmp/juan.csr -subj "/CN=juan/O=dev/O=api"
openssl req -new -key ~/.certs/kubernetes/sandbox/dbarranco.key -out /tmp/dbarranco.csr -subj "/CN=dbarranco/O=sre"

## Copy the requests to the server (NOT THE PROPER WAY)
scp -i antonio_ramos.pem /tmp/jsalmeron.csr bitnami@$SANDBOX_IP:/tmp/
scp -i antonio_ramos.pem /tmp/juan.csr bitnami@$SANDBOX_IP:/tmp/
scp -i antonio_ramos.pem /tmp/dbarranco.csr bitnami@$SANDBOX_IP:/tmp/

#
# This part is done on the server side
#

## Certificates
openssl x509 -req -in /tmp/jsalmeron.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/jsalmeron.crt  -days 500 
openssl x509 -req -in /tmp/juan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/juan.crt  -days 500 
openssl x509 -req -in /tmp/dbarranco.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/dbarranco.crt  -days 500 

#
# This part is done again on the client side
#

# Download the generated certificate (NOT THE PROPER WAY)
scp -i antonio_ramos.pem bitnami@$SANDBOX_IP:/tmp/jsalmeron.crt ~/.certs/kubernetes/sandbox/jsalmeron.crt
scp -i antonio_ramos.pem bitnami@$SANDBOX_IP:/tmp/juan.crt ~/.certs/kubernetes/sandbox/juan.crt
scp -i antonio_ramos.pem bitnami@$SANDBOX_IP:/tmp/dbarranco.crt ~/.certs/kubernetes/sandbox/dbarranco.crt

scp -i antonio_ramos.pem bitnami@$SANDBOX_IP:/etc/kubernetes/pki/ca.crt  ~/.certs/kubernetes/sandbox/ca.crt

# Check the content of the certificates
openssl x509 -in $HOME/.certs/kubernetes/sandbox/jsalmeron.crt -text -noout 
openssl x509 -in $HOME/.certs/kubernetes/sandbox/juan.crt -text -noout 
openssl x509 -in $HOME/.certs/kubernetes/sandbox/dbarranco.crt -text -noout 

# Add new kubectl context

kubectl config set-cluster sandbox --certificate-authority=$HOME/.certs/kubernetes/sandbox/ca.crt --embed-certs=true --server=https://${SANDBOX_IP}:6443

# Add new kubectl context for jsalmeron

kubectl config set-credentials jsalmeron --client-certificate=$HOME/.certs/kubernetes/sandbox/jsalmeron.crt --client-key=$HOME/.certs/kubernetes/sandbox/jsalmeron.key --embed-certs=true

kubectl config set-context jsalmeron-sandbox --cluster=sandbox --user=jsalmeron

# Add new kubectl context for juan

kubectl config set-credentials juan --client-certificate=$HOME/.certs/kubernetes/sandbox/juan.crt --client-key=$HOME/.certs/kubernetes/sandbox/juan.key --embed-certs=true

kubectl config set-context juan-sandbox --cluster=sandbox --user=juan

kubectl config set-credentials dbarranco --client-certificate=$HOME/.certs/kubernetes/sandbox/dbarranco.crt --client-key=$HOME/.certs/kubernetes/sandbox/dbarranco.key --embed-certs=true

kubectl config set-context dbarranco-sandbox --cluster=sandbox --user=dbarranco

#create namespace
kubectl create namespace team-vision
kubectl create namespace team-api
#on describe node we have 
#Allocatable:
# cpu:                2
# ephemeral-storage:  28474712017
# hugepages-2Mi:      0
# memory:             3946712Ki
# pods:               110
#create quota 80% cpu and 80% mem for namespace team-vision
kubectl create -f yaml/team-vision-quota.yaml
#create quota 20% cpu and 20% mem for namespace team-api
kubectl create -f yaml/team-api-quota.yaml
#create limit 1 core and 100M for namespace team-api containers
kubectl create -f yaml/team-api-limitrange.yaml


#create cluster roles, we will use also cluster rol view
kubectl create -f yaml/manager-cr.yaml
kubectl create -f yaml/managernodelete-cr.yaml
kubectl create -f yaml/secretmanager-cr.yaml



#create role binding for dev group using rol cluster view for both namespaces
kubectl create -f yaml/team-vision-dev-view-rb.yaml
kubectl create -f yaml/team-api-dev-view-rb.yaml

#create role binding for vision group using rol cluster manager-cr for namespace team-view
kubectl create -f yaml/team-vision-vision-manager-rb.yaml
#create role binding for tech-lead group using rol cluster manager-cr for namespace team-view
kubectl create -f yaml/team-vision-tech-lead-manager-rb.yaml
#create role binding for tech-lead group using rol cluster manager-cr for namespace team-api
kubectl create -f yaml/team-api-tech-lead-manager-rb.yaml
#create role binding for api group using rol cluster managernodelete-cr for namespace team-api
kubectl create -f yaml/team-api-api-managernodelete-rb.yaml
#create role binding for sre group using rol cluster secretmanager-cr for  both namespace 
kubectl create -f yaml/team-api-sre-secretmanager-rb.yaml
kubectl create -f yaml/team-vision-sre-secretmanager-rb.yaml


# Set new context
kubectl config use-context jsalmeron-sandbox



