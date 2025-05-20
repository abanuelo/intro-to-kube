# Kubernetes: Managing Containers at Scale

## Background

This repo will contain examples to learn from:

- Creating a shared volume mounts for Databases
- Creating highly available (HA) websites using Deployments
- Deploying basic Services to communicate with HA pods
- Calico Networking for Pod-to-Pod communication
- Common K8s troubleshooting
- Basic K8s DevOps with Tekton
- Role-Based Access Control (RBAC) for cluster/user resource control

We will be using [minikube](https://minikube.sigs.k8s.io/docs/) on [GitHub Codespaces](https://github.com/features/codespaces) to explore K8s. To learn how to setup your codespace environment, [please reference this document](https://corise.com/course/kubernetes-managing-containers-at-scale/v2/module/codespace-setup).

## Outline

- Week 1.0

  a. **[Scavenger Hunt (Optional)](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/scavenger-hunt)** - helps us explore our minikube environment and how to use the `kubectl` tool.

  b. **[Cyber Monday](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/project-1-instructions)** - main project focused on exploring Deployments, Horizontal Pod Autoscalers, and Services.

- Week 2

  a. **[Pesky Persistent DB](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/project-2-instructions)** - explore deploying databases in microservice ecoysystem with the help of Deployments, Configmaps, and Persistent Volumes

- Week 3

  a. **[RBAC-to-the-future](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/module/project-3-instructions#corise_clm9w276p000j3b7lvx4bov7v)** - learn about introducing role-based access control on cluster resources to help scale users interacting with our clusers

  b.  **[Calico](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/module/project-3-instructions#corise_clm9w2tpt000k3b7ld7w684cy)** - learn about the basics of pod-to-pod networking to create finer control of cluster resources.

- Week 4

  a. **[Tekton](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/module_clmpekrcy008l127k3gssb6kp)** - learn about the basics using Tekton for CI/CD in kubernetes
