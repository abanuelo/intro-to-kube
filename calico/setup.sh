# setups up three namespaces
kubectl create ns namespace-a
kubectl create ns namespace-b
kubectl create ns namespace-c

# Create some nginx pods in namespace a and namespace c
kubectl run nginx-a --image=nginx:latest --restart=Never --port=80 --namespace namespace-a
kubectl run nginx-b --image=nginx:latest --restart=Never --port=80 --namespace namespace-b

# Create some postgres pod inside namespace c
kubectl apply -f postgres-pod.yml