# create namespaces
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod
kubectl create namespace database
kubectl create namespace backup

# create resources
kubectl config set-context --current --namespace=dev
kubectl create -f ./k8s/nginx-deployment.yml
kubectl config set-context --current --namespace=staging
kubectl create -f ./k8s/nginx-deployment.yml
kubectl config set-context --current --namespace=prod
kubectl create -f ./k8s/nginx-deployment.yml
kubectl config set-context --current --namespace=database
kubectl create -f ./k8s/postgres-pod.yml
kubectl config set-context --current --namespace=backup
kubectl create -f ./k8s/postgres-pod.yml

# go back to default namespace
kubectl config set-context --current --namespace=default