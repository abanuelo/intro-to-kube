# Cyber Monday

Hey there, Rockstar Engineer at StartupCo! 🎉 Guess what's just around the corner? The craziest shopping day of the year, Cyber Monday! 💻💥 We need to prepare our web app for this epic event, and it's going to be a wild ride! 🎢

We're counting on you to configure a highly available web app that can handle the massive traffic onslaught. 🚀 Don't worry we aren't exposing the app to the public yet, we just need all the pieces in place for when we do!

We will:

- Deploying multiple [nginx containers](https://hub.docker.com/_/nginx) 🐳 using a Deployment with 3 ReplicaSets and a CPU resource request of 100m. This will ensure our app is ready to handle the surge!
- Add a HorizontalPodAutoscaler to wrap around our Deployment and autoscale the replicas based on average CPU utilization. We will try to maintain an average CPU utilization of 50% and scaling up an down when necessary. When things get 🔥, it'll summon reinforcements, increasing replicas up to 20! We'll set a minimum of 1 replica, so our app is always up and running.

Get ready to configure this epic setup, and let's make this Cyber Monday the stuff of legends! 🎆 Best of luck, and let's rock this! 🤘

## Setup

Start your minikube and let the games begin!

```
minikube start
```

0. Lucky for you, some of your teammates, have already started writing a Deployment YAML called `nginx-deploy.yml`. Please refer to [K8s Deployment documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) as needed. Complete the YAML file to

   > a. Spin up an nginx container

   > b. Set CPU resource request to 100m

1. Once you feel confident in your code run the snippet below. It will create your Deployment in your default namespace. By creating a branch prefixed with `cyber-*` and pushing it up, we can check if your deployment is giving the correct information we need here.

```
kubectl apply -f nginx-deploy.yml
```

2. An intern started working on building out the HorizontalPodAutoscaler YAML called `nginx-scaler.yml`. Please refer to [K8s HPA Documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) as needed. Complete the YAML file to:

   > a. Set target to nginx deployment

   > b. Set minimum replicas to 1

   > c. Set maximum replicas to 20

   > d. Set target CPU utilization to 50%

3. Once you feel confident in your code run the snippet below. It will attach an HPA to your Deployment and just enable autoscaling of our web application. By creating a branch prefixed with `cyber-*` and pushing it up, we can check if your HPA is giving the correct information we need here.

4. Let's test see the results of your autoscaling by increasing the load. Run the snippet of code below and visualize load scale the pods by running `kubectl get hpa nginx --watch`. If you see pods scale up as a result, then congratulations looks like your job is done!

```
kubectl run -i --tty load-generator --rm --image=nginx --restart=Never -- /bin/sh -c "while sleep 0.01; do echo 'hello world'; done"

```
