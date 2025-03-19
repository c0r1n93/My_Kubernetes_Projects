# TP-2: Deploy your First Application
# Overview

In this TP, you will deploy your first Kubernetes application using pods and deployments. You will also expose a pod, update a deployment, and manage resources using both declarative and imperative approaches. Finally, you will organize and push your work to GitHub.

# Deploying a Pod with a Specific Color

   1. Writing a Pod Manifest (pod.yml)

       Create a YAML file named pod.yml and add the following;

apiVersion: v1
kind: Pod
metadata:
  name: webapp-red
  labels:
    app: webapp
spec:
  containers:
    - name: webapp
      image: mmumshad/simple-webapp-color
      env:
        - name: APP_COLOR
          value: "red"
      ports:
        - containerPort: 8080

   2. Deploying the Pod and Verifying Its Status

       Execute the following commands:

           kubectl apply -f pod.yml
           kubectl get pods    

   3. Exposing the Pod

       Expose the pod using port forwarding . Use the following command :

     kubectl port-forward webapp-red 8080:8080 --address 0.0.0.0 

   4. Verify the accesibility on your navigator. Use the following 

    http://<NODE_IP>:8080

# Deploying an Nginx Application with Replicas

   1. Writing a Deployment Manifest (nginx-deployment.yml)

       Create a YAML file named nginx-deployment.yml and add the following; 

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.18.0
          ports:
            - containerPort: 80

   2. Deploying and Checking Resources

       Run the following commands: 

     kubectl apply -f nginx-deployment.yml 

     kubectl get deployments (lists all the Deployments in your Kubernetes cluster.)

     kubectl get replicasets (lists all ReplicaSets in the cluster)

     kubectl get pods -o wide ( Lists all pods with detailed information)


# Updating the Deployment to Use the Latest Nginx Version


   1. Modifying the Deployment Manifest

        Update nginx-deployment.yml to use the latest Nginx image: 


apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80


   2. Now apply the update

         kubectl apply -f nginx-deployment.yml
         kubectl get replicasets
         kubectl describe deployment nginx-deployment


   3. Expected Outcome

      - A new ReplicaSet for nginx:latest will be created.

      - The old ReplicaSet for nginx:1.18.0 will still exist.

      - The new  ReplicaSet (nginx:latest) will be the active one.     


# Cleaning Up and Recreating Resources Imperatively

   1. Deleting Resources

        Remove the created resources using the following commands ;

             kubectl delete pod webapp-red
             kubectl delete deployment nginx-deployment

   2. Recreating Resources Using Imperative Commands

        Execute  the following commands ;

           kubectl run webapp-red --image=mmumshad/simple-webapp-color --env="APP_COLOR=red" --port=8080
           kubectl expose pod webapp-red --port=8080 --target-port=8080

           kubectl create deployment nginx-deployment --image=nginx:1.18.0 --replicas=2
           kubectl set image deployment/nginx-deployment nginx=nginx:latest  


# Organizing and Pushing to GitHub

   1. Start by creating Directories and Moving Files

         Execute the following commands ;    

             amkdir -p Kubernetes-training/tp-2
             mv pod.yml nginx-deployment.yml Kubernetes-training/tp-2/

   2.  Initializing and Pushing to GitHub      

          Execute the following commands ; 

             cd Kubernetes-training
             git init
             git add .
             git commit -m "Added Kubernetes manifests for TP-2"
             git branch -M main
             git remote add origin <GITHUB_REPO_URL>
             git push -u origin main   








