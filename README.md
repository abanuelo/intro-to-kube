# Kubernetes: Managing Containers at Scale

## Background

This repo will contain examples to learn:

- Creating shared volume mounts for Databases
- Creating highly available (HA) websites using Deployments
- Deploying basic Services to communicate with HA pods
- Calico Networking for Pod-to-Pod communication
- Common K8s troubleshooting
- Basic K8s logging and metrics
- Role-Based Access Control (RBAC) for cluster/user resource control

We will be using [minikube](https://minikube.sigs.k8s.io/docs/) on [GitHub Codespaces](https://github.com/features/codespaces) to explore K8s. To learn how to setup your codespace environment, [please reference this document](https://corise.com/course/kubernetes-managing-containers-at-scale/v2/module/codespace-setup).

## Outline

- Week 1

  a. **Scavenger Hunt (Optional)** - helps us explore our minikube environment and how to use the `kubectl` tool.

  b. **Cyber Monday** - main project focused on exploring Deployments, Horizontal Pod Autoscalers, and Services.

- Week 2 - **Pesky Persistent DB** - explore deploying databases in microservice ecoysystem with the help of Deployments, Configmaps, and Persistent Volumes

- Week 3 - **RBAC-to-the-future** - learn about introducing role-based access control on cluster resources to help scale users interacting with our clusers

- Week 4 - **Calico** - learn about the basics of pod-to-pod networking to create finer control of cluster resources.
