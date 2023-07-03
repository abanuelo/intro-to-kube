# RBAC To The Future

🌱 Hey there, fellow adventurer at StartupCo! 🚀 Let me tell you a little story to describe why we need to add Role-Based Access Control (RBAC) as our company grows. And so RBAC to the Future we go. 🌟

At first, it was all good vibes and everyone could see the pods dancing around, spreading their digital wonders. 🎉 But as our microservice world expanded and more components joined the party, we realized the need for a touch of order and security. 🔒

So, we need the mighty power of Role-Based Access Control (RBAC) to bring stability to our company. We needed to define a new role known as the PodReader, a gentle guardian 🛡️, and PodWriter, the pen to our paper 🖋️.

With the PodReader role, users would gain the ability to peer into the world of our pods. They would have the superpower to observe and understand the pod details, but nothing more. No meddling with the pod configurations or causing chaos in the microservice realm!

And with the power of PodWriter role, we could grant select individuals the ability to edit the pod configurations and weave their creativity into our ever-evolving universe. 🎨

May our StartupCo continue to grow, thrive, and spread its digital wonders throughout the land! 🌍💫

## Setup

Start up your `minikube` environment by running:

```
minikube start
```

Before we begin we need to be able to create a client certifcate for our use. Run the `client-cert.sh` to complete that process.

You can then verify that the script ran successfully
by running

```
kubectl config view
```

and seeing something that looks like the following:

```

```

0. First let's start off with the PodReader. We have two files:

   - `podreader-role.yml` contains the [Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) definition which define which resources can be accessed via which operations/verbs. In this case we want only the `Pod` resources defined for this Role with verbs `get`, `watch`, and `list`.
   - `podreader-rolebinding.yml` binds the role created above to the podreader user defined when running `client-cert.sh`. This is known as a [RoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

   When you are ready run `kubectl apply -f podreader-role.yml` and `kubectl apply -f podreader-rolebinding.yml`.

1. Next we will work on defining the PodWriter. We have two files as well:

   - `podwriter-role.yml` will find a Role on the `Pod` resources with verbs `get`, `create`, `delete`, `update`, `edit`, and `exec`.
   - `podwriter-rolebinding.yml` will create the necessary RoleBinding to the podwriter user.

   When you are ready run `kubectl apply -f podwriter-role.yml` and `kubectl apply -f podwriter-rolebinding.yml`.

2. Next we are going to try some of operations for the podreader to determine if we can truly just read pods. Let's switch into the podreader context:

```
kubectl config use-context podreader-context
#should fail
kubectl create namespace test
# should pass
kubectl get pod #should pass
```

3. We will do the same for podwriter. Let's run the following lines of code

```
kubectl config use-context podwriter-context
#should pass
kubectl get pod
# should pass
kubectl edit pod <pod-name>
# should fail
kubectl create namespace test
```

## Troubleshooting
