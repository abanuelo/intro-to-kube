# Pesky Persistent Data

## Disclaimer

The project has many components, and we encourage you to complete as many as you can! That said, we highly encourage you to submit your work even if your notebook is only partially completed - the TA can help review your work and provide tips on any places that you got stuck or have further questions!

## Background 
Once upon a time at StartupCo, an ingenious engineer embarked on a mission to create a 🐘PostgreSQL database that would hold the key to the company's data treasure trove. Despite their best efforts, the database refused to persist data. Later it was discovered that the PostgreSQL DB was stored as a Deployment! Deployments can create Pods with persistent data but that data needs to be brand new for each Pod every time or shared across all Pods. And when they performed maintenance on some Pods in this Deployment, it was hard to find a way to maintain the storage such that each pod is attached to the right set of data.

Undeterred by this setback, our determined engineer donned their virtual superhero cape and hatched a brilliant plan. With a wave of their coding wand, they transformed Deployment by attaching a Persistent Volume! A Persistent Volume is needed to determine where to safely mount data in their container. And of course if you have a Persistent Volume, you need to define a Persistent Volume Claim to determine a request for storage by a user.

As the pieces fell into place, our engineer activated a Service, allowing them to interact with the postgres database in all its glory. But given the heavy load on their plate from the latest sprint, they were unable to develop the Deployment, Persistent Volume, nor Persistent Volume Claim.

This is where a newest protoge, comes into existence. Our engineer's persistence paid off, and the team rejoiced, knowing that their data was in capable hands. 🎉💾

## Setup

Start up your `minikube` environment by running:

```
cd pesky-persistent-db
minikube start
```

## Testing

We have configured [GitHub Actions](https://github.com/features/actions) with minikube! GitHub Actions works as a CI/CD tool but for our intents and purposes, we will use it to create an autograder for your `yml` file changes. To test, create a branch in our `intro-to-kube` repo prefixed with
`persistent-*` and push changes up to that branch. [See the output of your results here for reference](https://github.com/abanuelo/intro-to-kube/actions/workflows/pesky-persistent-db.yml).

```
# create your branch
git checkout -b persistent-<github-username>
# add your local changes
git add .
# commit your changes
git commit -m "<describe changes made>"
# push your changes to your upstream branch
git push -u origin persistent-<github-username>
```

## Main Project

### Introduction to Services

The [Service](https://kubernetes.io/docs/concepts/services-networking/service/) API was intended to provide a Domain Name System (DNS) to be able to connect with the Pods attached to the Deployment from a single IP address. As we noticed from week 1, when creating a deployment, each Pod will have its IP address. These pods, however, can die, get replaced, restart and mostly likely, will never keep the IP:

```
kubectl get pods -o wide
NAME                                  READY   STATUS    RESTARTS      AGE    IP            NODE       NOMINATED NODE   READINESS GATES
nginx-deployment-57d84f57dc-9dpxx     1/1     Running   0             18m    10.244.0.56   minikube   <none>           <none>
nginx-deployment-57d84f57dc-ccw6d     1/1     Running   0             18m    10.244.0.55   minikube   <none>           <none>
nginx-deployment-57d84f57dc-qh6k9     1/1     Running   0             18m    10.244.0.54   minikube   <none>           <none>
```

   As a result, Services were created as a way to connect to any such Pod. Services come in many flavors, but the two most important to focus on for this class are:

   a. [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip) - assigns an IP from a pool of IPs cluster has reserved. This is meant for internal services (not exposed to the public).

   b. [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) - allocates a port from ranges 30000-32767 (by default) to all relevant pods and forwards traffic to the service. This is meant for external exposure of services.

   For now we are assuming that we want to provide a NodePort Service for our postgres database. To illustrate how the services work, please refer to the `./pesky-persistent-db/examples` folder and run:

   ```
   kubectl apply -f ./examples/nginx-deployment.yml
   kubectl apply -f ./examples/nginx-service.yml
   ```

### Services on Minikube

   After having run the files from inside the `./pesky-persistent-db/examples` folder, we will illustrate [how to work with Services in minikube](https://minikube.sigs.k8s.io/docs/handbook/accessing/). 

   Since the minikube network is using the Docker driver, the Node IP is not reachable directly unfortunately. What this means for us is we cannot directly curl the IP of a given pod (ie `curl -v http://10.244.0.55`). Minikube has offered some helpful tutorials you may use to test your NodePort Service for this project: [see tutorial here](https://minikube.sigs.k8s.io/docs/tutorials/kubernetes_101/module4/). 

   At a high-level, what you need to do to connect to these IPs is to launch your NodePort Service and run:

   ```
   minikube service <service-name> --url
   ```

   Using this URL, you can now run curl commands against it to query the Pod IPs. If you applied the k8s objects from inside the `./pesky-persistent-db/examples` folder we encourage you to run:

   ```
   curl -v $(minikube service nginx-nodeport-service --url) 
   ```

### Action Items

0. Let's create our NodePort Service for our postgres database. 

   ```
   kubectl apply -f postgres-service.yml
   ```

1. Let's start with the low-hanging fruit first. We are going to add values to a K8s ConfigMap needed for our Postgres Database. Please define the values in the `postgres-configmap.yml` file. [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) are intended to define non-confidential key-value pairs. Ideally, we would use a K8s [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) to store our DB connection info, but for the purposes of easy debugging and high visibility, this will work for now. To test your change please run:

   ```
   kubectl apply -f postgres-configmap.yml
   ```

   **Hint:** The data you enter in this file will follow a key,value pair format (ie `password-key: password-value`)

2. Now that we have this, let's work to define the [Persistent Volume (PV) and Persistent Volume Claim (PVC)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) within the `postgres-persistent.yml` file. 


   Here is where the magic comes into place for make our data persistent. 
   > What are Volumes? 

   > The files a container in a Pod has will disappear once the Pod dies, gets deleted, restarts, etc. Also the files in these containers are independent from one another. This means files inside container of Pod A will not share files from inside container of Pod B. Volumes attempt to solve this by creating a directory that is accesssible to containers in a Pod and are independent of the Pod lifecycle. ConfigMaps are a type of Volume that mount their key,value pairs inside a Pods `/etc/config/log_level` directory.
   

   > What are Persistent Volumes?

   > Persistent Volumes (PVs) are physical resources in a cluster (just like a Node) that allows you to plugin into a Pod. In our case for our assignment, a snapshot of the contents of our database. 

    > What are Persistent Volumes Claims?

   > Persistent Volumes Claims (PVCs) are requests for storage by a user (just like a Pod consumes resources on a Node). 

   For the Persistent Volume you will

   - set the accessModes as ReadWriteMany
   - set the capacity to 5Gi
   - set the hostPath to /mnt/data
   - set the storageClassName to manual

   For the Persistent Volume Claim you will:

   - set the accessModes as ReadWriteMany
   - set the resource requests storage to 5Gi
   - set the storageClassName to manual

   You can create the objects by running the snippet below.

   ```
   kubectl apply -f postgres-persist.yml
   ```

   **Hint:** You may want to run `kubectl explain pv.spec --recursive` and `kubectl explain pvc.spec --recursive` to find where exactly to add these specifications in your YAML file. 

3. Now we need to configure the [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to 

   a. add the key-value pairs defined from the `postgres-configmap.yml` file 

   b. point to specific a place to mount data on the containers for the pods, in this case it is `/var/lib/postgresql/data` which is the directory PostgresSQL DB stores data 

   c. point to our created Persistent Volume Claim for our deployment to be able to mount the data to the requested directory inside the Pod from the step above..

   More details are available within the `postgres-deployment.yml`. For now we will only configure a single replica but feel free to change that as you wish. Once you feel confident, run the snippet of code below:

   ```
   kubectl apply -f postgres-deployment.yml
   ```

   For this step, we before we test out the connection to the Postgres DB via our service, give it a go by `exec`ing into the pod created by the Deployment to run the following command:

   ```
   # grab the pod name via
   kubectl get pod
   # check the postgres connection
   kubectl exec -it <pod name> -- psql -h localhost -U admin --password -p 5432 postgresdb
   ```

   If you can connect to the postgres pod then you have successfully (a) and (b). We will check (c) in the next step.

   **Troubleshooting Tips**: 
   - You are on the right path if when you `kubectl describe` your postgres Pod you see the volume mount in the `Volumes: ` section:
   ```
   Volumes:
      postgredb:
         Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
         ClaimName:  postgres-pv-claim
         ReadOnly:   false
   ```
   - To see if data is actually getting populated into the PV run. The contents of this should be what is identical to whats inside the `/var/lib/postgresql/data` inside the Pod:
   ```
   # See contents of PV
   # command below opens up docker container acting as a Node
   minikube ssh -p minikube 
   sudo ls /mnt/data

   # Expected to equal contents inside Pod
   kubectl exec -it <pod name> -- ls /var/lib/postgresql/data
   ```
   - To check if the ConfigMap has been properly configured run `kubectl describe deployment postgres` and see if the `Environment Variables from: ` looks like:

   ```
   Environment Variables from:
      postgres-config  ConfigMap  Optional: false
   ```

4. Lastly let's test out to see if we can persist our database!

   Let's test the connection to the DB from outside the cluster from the service by running:

   ```
   sudo apt update
   sudo apt -y  install postgresql postgresql-contrib

   psql  -h $(minikube ip) -p $(minikube service postgres --url --format={{.Port}}) -U admin -d postgresdb --password
   ```

   Let's create a table using the following command. Let's also try to INSERT some data into the table

   ```
   CREATE TABLE roles(
      role_id serial PRIMARY KEY,
      role_name VARCHAR (255) UNIQUE NOT NULL
   );
   INSERT INTO PUBLIC.ROLES VALUES (1, 'student');
   ```

   After running this command try to delete the Pod and wait for the Deployment to spin up a new one:

   ```
   # get the pod name
   kubectl get pod
   # delete the pod
   kubectl delete pod <pod-name>
   # check to see if new pod spins up
   kubectl get pod
   ```

   And lastly check if the "roles" table exists with the entry we inserted:

   ```
    SELECT * FROM PUBLIC.ROLES;
   ```

   If you see the output below, you have successfully created persistent data!

   ```
      role_id | role_name
   ---------+-----------
         1 | student
   (1 row)
   ```

## Challenge + Extensions

0. As mentioned in the in step 1, it is not recommended to keep highly secure values inside a ConfigMap. Rework the `postgres-deployment.yml` to reference a [K8s Secret](https://kubernetes.io/docs/concepts/configuration/secret/) instead. Feel free to refer to [this GitHub thread](https://github.com/kubernetes/kubernetes/issues/70241#issuecomment-434242145) for assistance. Also feel free to use the `./challenges/postgres-secret.yml` file to make any edits.
1. What if our volume gets corrupted! Well that can always be a risk in the world of Kubernetes. As an extra extension, we recommend developing a backup process for our data. Kubernetes offers [VolumeSnapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/) that can faciliate the backup process. There is no one-size answer we can autograder here but we recommend to explore how to use VolumeSnapshots via [this blog](https://blog.palark.com/kubernetes-snaphots-usage/).