# Run only once minikube and relevant dependencies installed
if [ ! -f /usr/local/bin/minikube ]; then
  echo "Minikube not found. Please follow installation instructions in README.md"
fi
minikube start
kubectl create namespace scavenger
kubectl config set-context --current --namespace=scavenger
cd k8s
IFS=$'\n\t'
for f in $(ls)
do
	until kubectl create -f $f 2> /dev/null
	do
		sleep 10
	done
done
