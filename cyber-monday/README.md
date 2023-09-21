# [Cyber Monday](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/project-1-instructions)

## Disclaimer

If this is your first time working with kubectl to discover cluster resources, we strongly recommended diving into the [Scavenger project](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/scavenger-hunt) to learn about all about [minikube](https://minikube.sigs.k8s.io/docs/), k8s, and kubectl.

## Note

You can also follow along with the info through the Uplimit Course [here](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/enrollment/enrollment_clj4nmkr201xv12aw259t4xtw/module/project-1-instructions).

## Background

Hey there, Rockstar Engineer at StartupCo! 🎉 Guess what's just around the corner? The craziest shopping day of the year, Cyber Monday! 💻💥 We need to prepare our web app for this epic event, and it's going to be a wild ride! 🎢

We're counting on you to configure a highly available web app that can handle the massive traffic onslaught. 🚀 Don't worry we aren't exposing the app to the public yet, we just need all the pieces in place for when we do!

We will:

- Deploy a single nginx Pod with containerPort 80 and label `just-a-pod`
- Deploy multiple [nginx containers](https://hub.docker.com/_/nginx) 🐳 using a Deployment with 3 ReplicaSets. The nginx containers should also have a containerPort of 80 and a label `just-a-pod`.
- Use `kubectl cp` and `kubectl exec` commands to support an automated script to take backups of a log file within our pods and push it into our local machine.

Get ready to configure this epic setup, and let's make this Cyber Monday the stuff of legends! 🎆 Best of luck, and let's rock this!

## Setup

Start your minikube and let the games begin!

```
 minikube start
 
 cd cyber-monday
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

0. Let's start simple. Create a single nginx pod with
   > a. containerPort 80 
   
   > b. label `just-a-pod` from the nginx latest image
   
   Complete, `nginx-pod.yml`. Run the command below to test or see [Testing](#testing).

   ```
   kubectl apply -f nginx-pod.yml
   ```

1. Now we are going to take that same pod but wrap it in a deployment so that 3 Replicas of that Pod exist at any given time. Please refer to [K8s Deployment documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) as needed. Complete the YAML file to:

   > a. Add 3 replicas

   > b. Add a selector that matches labels `just-a-pod`

   > c. Add a template for the nginx container used in `nginx-pod.yml`

      Once you feel confident in your code run the snippet below or see [Testing](#testing).

   ```
   kubectl apply -f nginx-deploy.yml
   ```

2. As users start pinging these pods (which won't happen yet fortunately for us 😊), we want to collect metadata around what items they are purchasing for Cyber Monday. Since our logging and metrics aren't set in place yet, we are going to try to collect this metadata by supporting an automated script to take backups of a logfile within our pods and push it into our local machine. To do so we will:

      a. Copy our logging script `log.sh` into our pod that runs in the background and writes metadata to `/tmp/foo.log` every 3 seconds to simulate users pinging the pods and data getting logged.

      b. Run a kubectl command to copy the `/tmp/foo.log` file to our local machine's working directory `./cyber-monday/foo.log`

   To do so, we will be using the [`kubectl cp`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#cp) command to copy files to and from our pods and a [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#exec) command to execute the `log.sh` script.

3. Let's start on our single Pod created from the `nginx-pod.yml`. Run the appropriate `kubectl cp` to copy over the `log.sh` to the Pod's `/tmp/` directory. Write this command in the `backup.txt`.

4. Now let's run the `log.sh` script inside the Pod in the background using the appropriate `kubectl exec` command. The bash command we intend to run is: `nohup ./log.sh > /tmp/foo.log &` for reference. Write this command in `backup.txt`. To verify if this worked, you can use a `kubectl exec` command to cat the contents of that file using: `tail -n 10 /tmp/foo.log`.

5. Last but not least, let's write a `kubectl cp` command to copy the `/tmp/foo.log` file from inside the Pod onto our machine's current working directory. You can verify it works when the file `foo.log` appears in your current working directory. Write this command inside the `backup.txt` file.

## Challenge
0. We have added the automated scripting to our Pod created by `nginx-pod.yml`. However, we have not added that same logic to the Pods encapsulated by our Deployment. For this challenge, repeat the same steps for all pods in the deployment, but ensure that when copying the log files to our local machine, they are prefixed by the Pod's unique identifier.

