# Tekton - CI/CD for K8s

## Note

You can also follow along with the info through the Uplimit Course [here](https://uplimit.com/course/kubernetes-managing-containers-at-scale/v2/module/project-3-instructions#corise_clm9w276p000j3b7lvx4bov7v).

## Background

StartupCo is thinking of adding CI/CD in place to help with the automatic build, push, and deployment of its we applications to Kubernetes. 

As a result, they looked to Tekon .
🛠️. Tekton is a powerful Kubernetes-native framework for building continuous integration and continuous delivery (CI/CD) pipelines. Creating a simple project to automate a basic CI/CD pipeline using Tekton in a Minikube environment is a great way to learn and practice its usage. 

The goal for this project is to automate the process of building, pushing an Docker image to a container reigstry and deploying said image using Tekton on a local Minikube cluster 🐳.



## Setup

Start up your `minikube` environment by running:

```
cd tekton
minikube start
```

Next we will install the latest version of Tekon in our minikube cluster
```
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

Monitor the installation by calling and make sure that `tekton-pipelines-controller` and `tekton-pipelines-webhook` and `READY`:
```
kubectl get pods --namespace tekton-pipelines --watch

NAME                                           READY   STATUS              RESTARTS   AGE
tekton-pipelines-controller-6d989cc968-j57cs   0/1     Pending             0          3s
tekton-pipelines-webhook-69744499d9-t58s5      0/1     ContainerCreating   0          3s
tekton-pipelines-controller-6d989cc968-j57cs   0/1     ContainerCreating   0          3s
tekton-pipelines-controller-6d989cc968-j57cs   0/1     Running             0          5s
tekton-pipelines-webhook-69744499d9-t58s5      0/1     Running             0          6s
tekton-pipelines-controller-6d989cc968-j57cs   1/1     Running             0          10s
tekton-pipelines-webhook-69744499d9-t58s5      1/1     Running             0          20s
```

Next we are going to install the `tkn` CLI allowing us to gather the logs for our TaskRun or PipelineRuns that we trigger. 

```
curl -LO https://github.com/tektoncd/cli/releases/download/v0.32.0/tektoncd-cli-0.32.0_Linux-64bit.deb

sudo dpkg -i ./tektoncd-cli-0.32.0_Linux-64bit.deb

# confirm that tkn is installed
which tkn
> /usr/bin/tkn
```

## Testing

We have configured [GitHub Actions](https://github.com/features/actions) with minikube! GitHub Actions works as a CI/CD tool but for our intents and purposes, we will use it to create an autograder for your `yml` file changes. To test, create a branch in our `intro-to-kube` repo prefixed with
`tekton-*` and push changes up to that branch. [See the output of your results here for reference](https://github.com/abanuelo/intro-to-kube/actions/workflows/tekton.yml).

```
# create your branch
git checkout -b tekton-<github-username>
# add your local changes
git add .
# commit your changes
git commit -m "<describe changes made>"
# push your changes to your upstream branch
git push -u origin tekton-<github-username>
```

## Main Project

We will write the `build.yml`, `deploy.yml`, and `build-push-deploy-pipeline.yml` that will work to orchestrate the automatic release of updates to our web application at StartupCo. 

0. To get started we will be building up a [Task](https://tekton.dev/docs/getting-started/tasks/) to build and run test suites for our web application. A Task defines a series of Steps that run sequentially to perform logic that the Task requires. Every Task runs as a pod on the Kubernetes cluster, with each step running in its own container. Please complete the `tasks/build.yml` file by adding the following Steps to your Task:

    a. Clone the github repo from the params into a directory called: `/workspace/source` inside the Pod

    b. Make `/workspace/source` your workDir and run `npm install`. 

    c. Make `/workspace/source` your workDir and run `npm test`

    Once you are ready to test run `kubectl apply -f ./tasks/build.yml` and you can see its creation status by running `tkn task list`. You can also push up to a branch prefixed with `tekton-` to run automated tests against your changes.

1. Next up we will be writing the deploy Task. A couple of things to note, since minikube does not out-of-the-box support pulling pushing/pulling images from a container registry, the `push.yml` current mocks out the push of an image to Docker's container registry. In the [challenge](#challenge) section of this project, you can revisit our mocked code to get minikube to push up images of your web application to a container registry. 

    For now, the `tasks/deploy.yml` file assumes that we have pushed up `nginx:latest` image that we then update for the `k8s/nginx-deployment.yml`.  Please complete the `tasks/deploy.yml` file by adding the following Steps to your Task:

    a. Run  `kubectl apply -f /workspace/intro-to-kube/tekton/k8s/nginx-deployment.yml`

    b. Run: `kubectl set image deployment/nginx-deployment nginx=<IMAGE-NAME> -n=<NAMESPACE>` where `IMAGE_NAME` and `NAMESPACE` are passed as parameters to our Task.

    Once you are ready to test run `kubectl apply -f ./tasks/deploy.yml` and you can see its creation status by running `tkn task list`.

2. Let's add all the tasks together in a [Pipeline](https://tekton.dev/docs/getting-started/pipelines/). A Pipeline defines an ordered series of Tasks arranged in a specific execution order as part of the CI/CD workflow. Work to complete the `build-push-pipeline.yml` file by sequencing the Tasks as the file name suggests: build &rarr; push &rarr; deploy. Run `kubectl apply -f build-push-deploy-pipeline.yml` when finished.

3. Last but not least, let's run our `build-push-deploy-pipelinerun.yml` which is represented as a [PipelineRun](https://tekton.dev/docs/getting-started/pipelines/). A PipelineRun, represented in the API as an object of kind PipelineRun, sets the value for the parameters and executes a Pipeline. Run `kubectl apply -f build-push-deploy-pipelinerun.yml`. And afterwards we can see the live logs of our Tasks running in order by running:

    ```
    tkn pipelinerun logs build-push-deploy -f -n default
    
    # Or you can also describe the necessary pipelinerun
    tkn pipelinerun describe build-push-deploy
    ```

## Challenge

0. As we hinted in step 1 for the [Main Project](#main-project), we can actually push a real image to our registry and use it as part of the `deploy.yml` task. In order to do this, some pre-requistes include:

- Having access to a GitHub repo for a project that contains a Dockerfile ([example repo here](https://github.com/sahat/hackathon-starter)). If you personally have one, feel free to use yours.

    Now to get this working lets:
    
    a. Update `build.yml` and `build-push-deploy-pipeline.yml` to update the `REPO_URL`.

    b. Follow [this minikube guide on container registry add-ons](https://minikube.sigs.k8s.io/docs/handbook/registry/) to connect to your GitHub Container Registry account 

    c. In the `push.yml`, uncomment the boiler code near the end of the file.

    d. Update the necessary parameters in the `push` Task under the `build-push-deploy-pipeline.yml`.

    e. For the `deploy.yml`, change Steps to (1) point to a new Deployment file for your Dockerized app. Feel free to use the file in `k8s/app-deployment.yml` to guide that process. 