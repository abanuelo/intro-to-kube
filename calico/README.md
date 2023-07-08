# Calico Network Policy

In a distributed system architecture, where multiple services are deployed across different namespaces, it becomes crucial to establish network policies to regulate and secure service-to-service communication. This is the next move for StartUpCo.

We will use Calico as a network policy agent. Calico is a flexible and scalable networking and security solution that operates at the Kubernetes network layer. It provides a powerful framework for network policy enforcement by leveraging the inherent capabilities of the underlying network fabric. With Calico, organizations can create fine-grained policies to control traffic flow between namespaces, pods, and other resources, ensuring only authorized service-to-service communication.

![Calico](./media/calico.png)

We will construct the following networking scheme:

- Ingress Policy for Namespace A: A network policy should be defined in namespace A to specify the ingress rules. This policy ensures that only incoming traffic from services residing in namespace B is permitted. It can be configured to accept traffic only from the specific namespace B's IP range or by referencing the namespace B's labels and/or pod labels.
- Egress Policy for Namespace A: To further enhance security, an egress policy should be enforced in namespace A. This policy restricts outgoing traffic from services in namespace A, allowing communication with services residing in namespace B and namespace C.
- Ingress Policy for Namespace B: Although not explicitly mentioned, it is also beneficial to implement an ingress policy in namespace B. This policy ensures that services in namespace B only accept requests from services residing in namespace A, creating a bi-directional secure communication channel. The ingress policy in namespace B can be defined similarly to the one in namespace A, allowing traffic only from the IP range or labels associated with namespace A.
- Ingress Policy for Namespace C: A network policy should be defined in namespace C such that it only receives requests from namespace A.
- Egress Policy for Namespace C: A network policy should be defined in namespace C such that it does not allow any outgoing network calls. This namespace is intended soley for data storage. We cannot expose this data to other services at the moment to safegaurd our application.

## Setup

Run minikube with the following command:

```
minikube start --network-plugin=cni --cni=calico
```

We have provided some template files in order for you to experiement with policy creation.

Also to start off the namespaces and pods, please run:

```
./setup.sh
```

For this assignment, we will be looking closely at the [Kubernetes Ingress and Egress policies from their documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies/). As a starter, try to find ways you can either

- (a) identify the pods belonging to a particular namespace using labels OR
- (b) identify the entire namespace from their labels OR
- (c) (not recommended) using the pods explict IPs to redirect traffic. This is not recommended since pods are usually deployed as a Deployment and their IPs are subject to change if they are deleted, cordoned, etc.

Please complete `network-policy-namespace-{a,b,c}.yml` and you can test your changes by pushing up a branch prefixed with `calico-`.
