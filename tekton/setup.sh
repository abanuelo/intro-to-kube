# install Tekton API Resources
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
# install tkn cli
curl -LO https://github.com/tektoncd/cli/releases/download/v0.32.0/tektoncd-cli-0.32.0_Linux-64bit.deb
sudo dpkg -i ./tektoncd-cli-0.32.0_Linux-64bit.deb
# grant all cluster role permissions to default service account
kubectl apply -f ./k8s/default-cluster-role.yml
kubectl apply -f ./k8s/default-cluster-role-binding.yml