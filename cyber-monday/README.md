# Cyber Monday

## Disclaimer

If this is your first time working with kubectl to discover cluster resources, we strongly recommended divinig into the `../scavenger/` folder to learn about all about [minikube](https://minikube.sigs.k8s.io/docs/), k8s, and kubectl.

## Background

Hey there, Rockstar Engineer at StartupCo! 🎉 Guess what's just around the corner? The craziest shopping day of the year, Cyber Monday! 💻💥 We need to prepare our web app for this epic event, and it's going to be a wild ride! 🎢

We're counting on you to configure a highly available web app that can handle the massive traffic onslaught. 🚀 Don't worry we aren't exposing the app to the public yet, we just need all the pieces in place for when we do!

We will:

- Deploying multiple [nginx containers](https://hub.docker.com/_/nginx) 🐳 using a Deployment with 3 ReplicaSets and a CPU resource request of 100m. This will ensure our app is ready to handle the surge!
- Add a HorizontalPodAutoscaler to wrap around our Deployment and autoscale the replicas based on average CPU utilization. We will try to maintain an average CPU utilization of 50% and scaling up an down when necessary. When things get 🔥, it'll summon reinforcements, increasing replicas up to 20! We'll set a minimum of 1 replica, so our app is always up and running.

Get ready to configure this epic setup, and let's make this Cyber Monday the stuff of legends! 🎆 Best of luck, and let's rock this!

## Setup

Start your minikube and let the games begin!

```
 minikube start --memory 2048 --cpus 2 --vm-driver=docker
 minikube addons enable metrics-server
 cd ./cyber-monday
```

## Testing

We have configured [GitHub Actions](https://github.com/features/actions) with minikube! GitHub Actions works as a CI/CD tool but for our intents and purposes, we will use it to create an autograder for your `yml` file changes. To test, create a branch in our `intro-to-kube` repo prefixed with
`cyber-*` and push changes up to that branch. [See the output of your results here for reference](https://github.com/abanuelo/intro-to-kube/actions/workflows/cyber-monday.yml).

```
# create your branch
git checkout -b cyber-<github-username>
# add your local changes
git add .
# commit your changes
git commit -m "<describe changes made>"
# push your changes to your upstream branch
git push -u origin cyber-<github-username>
```

## Main Project

0. Lucky for you, some of your teammates, have already started writing a Deployment YAML called `nginx-deploy.yml`. Please refer to [K8s Deployment documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) as needed. Complete the YAML file to

   > a. Spin up an nginx container

   > b. Set CPU resource request to 100m

   > c. Add CPU resource limit to 100m and memory to 64Mi

1. Once you feel confident in your code run the snippet below. It will create your Deployment in your default namespace. To test see [Testing](#testing).

   ```
   kubectl apply -f nginx-deploy.yml
   ```

2. An intern started working on building out the HorizontalPodAutoscaler YAML called `nginx-scaler.yml`. Please refer to [K8s HPA Documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) as needed. Complete the YAML file to:

   > a. Set target to nginx deployment

   > b. Set minimum replicas to 1

   > c. Set maximum replicas to 20

   > d. Set target CPU utilization to 50%

3. Once you feel confident in your code run the snippet below. It will attach an HPA to your Deployment and just enable autoscaling of our web application. To test see [Testing](#testing).

   ```
   kubectl apply -f nginx-scaler.yml
   ```

4. Let's test see the results of your autoscaling by increasing the load. Run the snippet of code below and visualize load scale the pods by running `kubectl get hpa nginx --watch`. If you see pods scale up as a result, then congratulations looks like your job is done!

   ```
   # First find a pod IP to hit by running
   kubectl get pods -o wide
   # Replace the IP in the curl command
   kubectl run -i --tty load-generator --rm --image=nginx --restart=Never -- /bin/sh -c "while sleep 0.001; do curl -v http://10.244.0.21; done"
   # In another terminal watch CPU utilization change
   kubectl get hpa nginx --watch
   # We may need to delete this pod to simulate this since we don't have a service
   ```

## Challenge

If the above steps have been completed, we encourage you to do some more thorough testing by adding a service. Note that in step 4 above, we needed to find the specific IP of a pod in order to determine if our HPA was working. Instead, we can add a [K8s Service](https://kubernetes.io/docs/concepts/services-networking/service/) that talks to our Deployment. By adding a service we can communicate to any given pod in our Deployment. Work on the `nginx-service.yml` file to add a service. To test your changes run the following snippet of code below:

```
# apply the service
kubectl apply -f nginx-service.yml
# minikube will export the service url, find yours by running
minikube service nginx --url
# Use that url to run this curl command:
curl -v $(minikube service nginx --url)
```
