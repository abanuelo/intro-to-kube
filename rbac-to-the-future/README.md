# RBAC To The Future - Role-Based Access Control

## Note

You can also follow along with the info through the Uplimit Course [here](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/project-2-instructions).

## Background

🌱 Hey there, fellow adventurer at StartupCo! 🚀 Let me tell you a little story to describe why we need to add Role-Based Access Control (RBAC) as our company grows. And so RBAC to the Future we go. 🌟

At first, it was all good vibes and everyone could see the pods dancing around, spreading their digital wonders. 🎉 But as our microservice world expanded and more components joined the party, we realized the need for a touch of order and security. 🔒

So, we need the mighty power of Role-Based Access Control (RBAC) to bring stability to our company. The company decided to create multiple namespaces:

-  `dev` - Developers work on application code, test new features, and perform integration testing in this namespace
- `staging` - Before deploying to production, applications are tested and validated in this environment to catch potential issues.
- `prod` - This is the live production environment where your applications and services serve end-users.
-  `database` - Database systems like MySQL, PostgreSQL, or MongoDB are isolated in this namespace to manage database-related resources.
- `backup` - Resources and tools for backup and disaster recovery, such as Velero, are placed in this namespace.

Now that each namespace has been created, there was a need to design new roles to control who has read/write/delete access to any resources in these namespaces

- `KubeAdmin` - Full access to the entire cluster, including all namespaces and resources.
- `Developer` - Permissions to create, read, update, and delete pods, services, config maps, and other application-specific resources within a `dev`, `staging`, and `prod` namespaces.
- `DBAdmin` - Permissions to manage storage-related resources like backups and direct data in databases from the `database` and `backup` namespaces.
- `Intern` - Permissions to view resources but not modify or create them in the `dev` namespaces exclusively

Your task here will be to create these Role, ClusterRoles, RoleBindings, and ClusterRoleBindings for our newest team members:

- **Jesus** - KubeAdmin
- **Joey** - Developer
- **Jessica** - DBAdmin
- **Jules** - Intern

And with the power of these roles, we could grant these individuals with the proper access to weave their creativity into our ever-evolving universe. 🎨

May our StartupCo continue to grow, thrive, and spread its digital wonders throughout the land! 🌍💫

## Setup

Start up your `minikube` environment by running:

```
cd rbac-to-the-future
bash setup.sh
```

Next create the following users and contexts by running the `create_users.sh` script:
```
bash create_users.sh
```

Afterwards run `kubectl config view` and expect to see something like this under `contexts` and `users`
```
kubectl config view
---
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/codespace/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 02 Sep 2023 23:10:39 UTC
        provider: minikube.sigs.k8s.io
        version: v1.31.2
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: Jessica
  name: Jessica-context
- context:
    cluster: minikube
    user: Jesus
  name: Jesus-context
- context:
    cluster: minikube
    user: Joey
  name: Joey-context
- context:
    cluster: minikube
    user: Jules
  name: Jules-context
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Sat, 02 Sep 2023 23:10:39 UTC
        provider: minikube.sigs.k8s.io
        version: v1.31.2
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: Jessica
  user:
    client-certificate: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jessica.crt
    client-key: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jessica.key
- name: Jesus
  user:
    client-certificate: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jesus.crt
    client-key: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jesus.key
- name: Joey
  user:
    client-certificate: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Joey.crt
    client-key: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Joey.key
- name: Jules
  user:
    client-certificate: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jules.crt
    client-key: /workspaces/intro-to-kube/rbac-to-the-future/user_certs/Jules.key
- name: minikube
  user:
    client-certificate: /home/codespace/.minikube/profiles/minikube/client.crt
    client-key: /home/codespace/.minikube/profiles/minikube/client.key
```

## Testing

We have configured [GitHub Actions](https://github.com/features/actions) with minikube! GitHub Actions works as a CI/CD tool but for our intents and purposes, we will use it to create an autograder for your `yml` file changes. To test, create a branch in our `intro-to-kube` repo prefixed with
`rbac-*` and push changes up to that branch. [See the output of your results here for reference](https://github.com/abanuelo/intro-to-kube/actions/workflows/rbac-to-the-future.yml).

```
# create your branch
git checkout -b rbac-<github-username>
# add your local changes
git add .
# commit your changes
git commit -m "<describe changes made>"
# push your changes to your upstream branch
git push -u origin rbac-<github-username>
```

## Main Project

0. Let's start with easiest [Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) and [RoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to build. Let's give read only access to the `Intern` role by defining `get`, `watch`, and `list` actions to `Pod` and `Deployment` resources strictly to the `dev` namespace. Afterwards bind this `Role` to Jules via the `RoleBinding`. When you are ready run:

   ```
   kubectl apply -f ./roles/intern.yml
   ```

   To test if Jules has the proper restrictions in place by running:
   ```
   # change to the Jules user context
   kubectl config use-context Jules-context

   # listing the pods within the staging namespace should fail ❌
   kubectl get pods --namespace staging

   # creating resources should fail ❌
   kubectl run my-pod --image=nginx --namespace dev

   # listing the pods within the dev namespace should pass ✅ 
   kubectl get pods --namespace dev
   ```

      You can run similar tests for the remaining Roles and RoleBindings we will create next or look at the [Testing](#testing) for more details.

1. The next Role to build will be `DBAdmin`. Here we want to grant the database admin to do any read/writes they need to any resources strictly within the `database` and `backup` namespaces. For this to happen, you will need to create a single Role and then create multiple RoleBindings per namespaces for the user Jessica:

      ```
      kubectl apply -f ./roles/db-admin/db-admin-role.yml

      # first within the database ns
      kubectl apply -f ./roles/db-admin/db-admin-rolebinding.yml

      # next within the backup ns
      kubectl apply -f ./roles/db-admin/db-admin-rolebinding.yml
      ```

      Feel free to construct similar tests we did in step 0 or rely on the CI/CD to test your implementation. 

2. For the next Role, it will follow a very similar date to step 1. Please create the `Developer` Role with full read/write access to all resources within the `prod`, `staging`, and `dev` namespaces. The exception here will be they can not DELETE any resources as that is the responsibility of the KubeAdmin. Apply the RoleBindings to Joey. Test as needed.

   ```
   kubectl apply -f ./roles/developer/developer-role.yml

   # re-run within relevant ns as needed
   kubectl apply -f ./roles/developer/developer-rolebinding.yml
   ```

3. For our last role, we will work to build the `KubeAdmin` role. This role grants a lot more permissions so instead of using the traditional Role and RoleBinding we will define a [ClusterRole and ClusterRoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/). This is perfect for non-namespaced resource management which in our case we hope that our KubeAdmin has all the necessary privileges in place to do any operation across all namespaces in our cluster. Grant this ClusterRoleBinding to Jesus.

   ```
   kubectl apply -f ./roles/kube-admin.yml
   ```

## Challenge
0. So far we have a relatively small team: you, Jessica, Jules, Joey, and Jesus. What if we get more engineers? What is there begins to be some specialization in the types of engineers we hire?

   In this challenge question, we will explore how we can introduce [Groups](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) as a way to improve our overall access to our RBAC microservice world. Please extend the current Role/RoleBindings/ClusterRoles/ClusterRoleBindings to create two groups. Please also allocate the following people under these [Groups](https://kubernetes.io/docs/reference/access-authn-authz/rbac/): 
   - **Software Engineers** - Joey, Jesus, and Jules
   - **Data Engineers** - Jessica