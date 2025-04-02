# TP-4: Persistent Storage in Kubernetes - MySQL Deployment

# Objective

This Project outlines how to deploy a MySQL pod in Kubernetes with persistent storage, using volumes, persistent volumes (PV), and persistent volume claims (PVC). It will guide you through creating and configuring the necessary YAML manifests for these components.

#  Create the MySQL Deployment Manifest with Persistent Volume

Here, you will begin by creating a MySQL deployment named mysql-volume with the following environment variables:

   - Database Name(db): eazytraining

   - Login: eazy

   - Password: eazy

   - Root Password: password

You will also ensure that the database's data directory is mounted to a persistent volume located in /data-volume on the node using a volume.

#  Create the mysql-volume.yml Manifest

Create a file named mysql-volume.yml with the following content:

```
apiVersion: v1
kind: Pod
metadata:
  name: mysql-volume
spec:
  containers:
    - name: mysql
      image: mysql:latest
      env:
        - name: MYSQL_DATABASE
          value: eazytraining
        - name: MYSQL_USER
          value: eazy
        - name: MYSQL_PASSWORD
          value: eazy
        - name: MYSQL_ROOT_PASSWORD
          value: password
      volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumes:
    - name: mysql-data
      hostPath:
        path: /data-volume
        type: Directory
```
# NOTE:

In this manifest:

 - The MySQL container is configured with the environment variables for database name, user, password, and root password.

 - The volumeMounts section mounts the local directory /data-volume to /var/lib/mysql inside the container to ensure data persistence.

1. Create the Pod

Run the following command to create the pod:

   kubectl apply -f mysql-volume.yml

2.  Verify that the Pod is Running

Check if the pod is running successfully with the following command:

    kubectl get pods

Ensure that the pod status is Running.

3. Verify the Volume Mount

To ensure that the pod is consuming the local /data-volume directory, use the following command to check the pod's volume mounts:

     kubectl describe pod mysql-volume

#  Create Persistent Volume (PV) and Persistent Volume Claim (PVC)

1.  Create the Persistent Volume Manifest (pv.yml)

Create a file named pv.yml with the following content. This will define a persistent volume of size 1 GB using the local directory /data-pv:

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data-pv
```

2. Create the Persistent Volume Claim Manifest (pvc.yml)

create a file named pvc.yml to define a persistent volume claim of size 100 MB that will use the previously defined persistent volume(pv):

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
```

- Run the following commands to create persistent volume (PV) and persistent volume claim (PVC)

    kubectl apply -f pv.yml

    kubectl apply -f pvc.yml

- Verify the creation of PV and PVC 
You can do this by verifying  the  status of the PV and PVC with the following commands:

    kubectl get pv

    kubectl get pvc

Ensure that the PVC is bound to the PV and both are in the Bound state.

# Deploy MySQL with PVC

Now, you will deploy MySQL in a pod that uses the PVC created earlier as its storage.

1.  Create the MySQL with PVC Manifest (mysql-pv.yml)

Create a file named mysql-pv.yml with the following content:

```
apiVersion: v1
kind: Pod
metadata:
  name: mysql-pv
spec:
  containers:
    - name: mysql
      image: mysql:latest
      env:
        - name: MYSQL_DATABASE
          value: eazytraining
        - name: MYSQL_USER
          value: eazy
        - name: MYSQL_PASSWORD
          value: eazy
        - name: MYSQL_ROOT_PASSWORD
          value: password
      volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumes:
    - name: mysql-data
      persistentVolumeClaim:
        claimName: mysql-pvc
```
# NOTE:

In this manifest:

- The MySQL container is configured as before, but now it uses the PVC (mysql-pvc) as its storage.

2. Create the Pod with PVC

Run the following command to create the pod:

   kubectl apply -f mysql-pv.yml

3. Verify the Pod and PVC Usage

To verify that the pod is consuming the PVC correctly, run:

   kubectl describe pod mysql-pv

Check if the pod is correctly mounted to the persistent storage.

#  Organize and Push Files to GitHub

- Create a tp-4 Directory in My_Kubernetes_Projects

On your local machine, navigate to the My_Kubernetes_Projects repository and create a directory named tp-4:

mkdir tp-4

- Copy Your Manifests

Copy all the manifests (mysql-volume.yml, pv.yml, pvc.yml, mysql-pv.yml) into the newly created tp-4 directory.

- Push the Directory to GitHub

git add tp-4/
git commit -m "Add Kubernetes manifests for TP4"
git push
