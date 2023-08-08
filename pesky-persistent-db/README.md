# Pesky Persistent Data

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

0. Luckily we have some resources: `postgres-service.yml`. The [Service](https://kubernetes.io/docs/concepts/services-networking/service/) was intended to provide a Domain Name System (DNS) to be able to connect with the Pods attached to the Deployment. Run the lines of code to create the Service

   ```
   kubectl apply -f postgres-service.yml
   ```

1. Let's start with the low-hanging fruit first. We are going to add values to a K8s ConfigMap needed for our Postgres Database. Please define the values in the `postgres-configmap.yml` file. [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) are intended to define non-confidential key-value pairs. Ideally, we would use a K8s [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) to store our DB connection info, but for the purposes of easy debugging and high visibility, this will work for now. To test your change please run:

   ```
   kubectl apply -f postgres-configmap.yml
   ```

2. Now that we have this, let's work to define the [Persistent Volume and Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) within the `postgres-persistent.yml` file. For the

   Persistent Volume you will

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

3. Now we need to configure the [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to point (a) specific a place to mount data on the containers for the pods, (b) add the key-value pairs defined from the `postgres-configmap.yml` file and (c) configure the persistent volume claim. More details are available within the `postgres-deployment.yml`. For now we will only configure a single replica but feel free to change that as you wish. Once you feel confident, run the snippet of code below:

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
