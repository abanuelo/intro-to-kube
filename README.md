# Basic Kubernetes (K8s)

This repo will contain examples to learn:

- Containers
- K8s workloads
- Basic services
- Networking
- Load balancing
- Common troubleshooting
- Metrics and logging

## Installing minikube

[minikube](https://minikube.sigs.k8s.io/docs/) is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

You will need:

a. Docker (or similarly compatible) container or a Virtual Machine environment

b. Kubernetes

1. Complete step 1. to install the necessary [minikube binary](https://minikube.sigs.k8s.io/docs/start/) for your machine.
2. Install kubernetes:

- [Install kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Install kubectl on macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [Install kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)

3. [Install Docker Engine](https://docs.docker.com/engine/install/). If you have the GUI option, it is recommended to install Docker Desktop.

## Why minikube?

Unfortunately, there is not an easy way to "containerize" minikube as it is already spun up as a docker container.

Gitpod offers [alternatives](https://www.gitpod.io/docs/configure/workspaces#is-it-possible-to-run-a-kubernetes-cluster-in-a-gitpod-workspace-using-minikube-or-kind-or-other-alternatives) to have a docker-in-docker solution for kubernetes through [K3s](https://k3s.io/), a lightweight version for kubernetes, but image setup takes >30 minutes and is limited to a single node control-plane.
