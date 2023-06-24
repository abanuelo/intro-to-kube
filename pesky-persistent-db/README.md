# Pesky Persistent Data

Once upon a time at StartupCo, an ingenious engineer embarked on a mission to create a 🐘PostgreSQL database that would hold the key to the company's data treasure trove. Despite their best efforts, the database refused to persist data. Later it was discovered that the PostgreSQL DB was stored as a Deployment! Deployments can create Pods with persistent data but that data needs to be brand new for each Pod every time or shared across all Pods. And when they performed maintenance on some Pods in this Deployment, it was hard to find a way to maintain the storage such that each pod is attached to the right set of data.

Undeterred by this setback, our determined engineer donned their virtual superhero cape and hatched a brilliant plan. With a wave of their coding wand, they transformed the database into a mighty 🏰StatefulSet, ready to endure the test of time. A StatefulSet allowed them to identify each Pod with a number and receiving a matching persistent storage. As part of the construction of the StatefulSet, they realized they needed the development of a Persistent Volume to determine where to safely mount data in their container. And of course if you have a Persistent Volume, you need to define a Persistent Volume Claim to determine a request for storage by a user.

As the pieces fell into place, our engineer activated a Service, allowing them to interact with the postgres database in all its glory. But given the heavy load on their plate from the latest sprint, they were unable to develop the StatefulSet, Persistent Volume, nor Persistent Volume Claim.

This is where a newest protoge, comes into existence. Our engineer's persistence paid off, and the team rejoiced, knowing that their data was in capable hands. 🎉💾

## Setup

Start up your `minikube` environment by running:

```
minikube start
```

0. Luckily we have some resources. We have a Secret and Service named `posgres-secret.yml` and `posgres-service.yml` respectively. The Secret was intended to store the username and passwords for the PosgresDB. The Service was intended to provide a Domain Name System (DNS) to be able to connect with the Pods attached to the StatefulSet. Run the lines of code to create the Service and Secret

```
kubectl apply -f postgres-secret.yml
kubectl apply -f postgres-service.yml
```

1. Now that we have this, let's work to define the [Persistent Volume and Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) within the `postgres-persistent.yml` file. For the

   Persistent Volume you will

   - set the accessModes as ReadWriteOnce
   - set the capacity to 2Gi
   - set the hostPath to /data/postgres
   - set the storageClassName to standard

   For the Persistent Volume Claim you will:

   - set the accessModes as ReadWriteOnce
   - set the resource requests storage to 2Gi
   - point to the Persistent volume name above

   You can create the objects by running the snippet below. To verify correctness please create a branch prefixed with `persist-*` and view the status on the repo's Actions folder.

   ```
   kubectl apply -f postgres-persist.yml
   ```

2. Now we need to configure the [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) to point (a) specific a place to mount data on the containers for the pods, (b) add the secrets defined from the `postgres-secret.yml` file and (c) configure the persistent volume claim. More details are available within the `postgres-stateful.yml`. For now we will only configure a single replica but feel free to change that as you wish. Once you feel confident, run the snippet of code below:

   ```
   kubectl apply -f postgres-stateful.yml
   ```

3. Lastly let's test out to see if we can persist our database!

Let's test the connection to the DB from outside the cluster from the service by running:

```
psql --host=$(minikube ip) \
     --port=$(minikube service postgres --url --format={{.Port}}) \
     --username=postgres \
     --dbname=postgres
```

Let's create a table using the following command:

```

```
