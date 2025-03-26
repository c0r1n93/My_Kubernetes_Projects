# TP-3: Creating a NodePort Service
# Objective

This project involves creating a Kubernetes service of type NodePort. The tasks include defining necessary manifests, deploying pods, and exposing them using a NodePort service.

# Create a Namespace

- Write a manifest file named namespace.yml to create a namespace called production:

```
apiVersion: v1
kind: Namespace
metadata:
  name: production
```  

- Apply the manifest to create the namespace:

 kubectl apply -f namespace.yml

# Deploy Pods

   - Pod with Red Color

Create a manifest file named pod-red.yml to deploy a pod using the mmumshad/simple-webapp-color image with the color set to red:

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-red
  namespace: production
  labels:
    app: web
spec:
  containers:
  - name: webapp-red
    image: mmumshad/simple-webapp-color
    env:
    - name: COLOR
      value: red
```      

   - Pod with Blue Color

Create another manifest file named pod-blue.yml to deploy a pod with the color set to blue:

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-blue
  namespace: production
  labels:
    app: web
spec:
  containers:
  - name: webapp-blue
    image: mmumshad/simple-webapp-color
    env:
    - name: COLOR
      value: blue
```      

- Apply both manifests to deploy the pods:

kubectl apply -f pod-red.yml
kubectl apply -f pod-blue.yml

# Create a NodePort Service

Write a manifest file named service-nodeport-web.yml to expose the pods via a NodePort service:

```
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: production
spec:
  type: NodePort
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      nodePort: 30008
```      

- Apply the manifest to create the service:

kubectl apply -f service-nodeport-web.yml

# Verify the Setup

- Check if the service is linked to the pods by running the following command:

kubectl describe service webapp-service -n production

Look for the Endpoints field to confirm that both pods are detected.

# Test the Application

Ensure the application is accessible by opening port 30008 on your node and accessing the service on your navigator;

http://<NODE_IP>:30008

# Push to GitHub

Clone your repository if not already done:

git clone <your-github-repo>
cd Kubernetes-Projects

Create a new directory tp-3 and move manifests into it:

mkdir tp-3
mv namespace.yml pod-red.yml pod-blue.yml service-nodeport-web.yml tp-3/

then execute the following commands;
     
     git add .
     git commit -m "Added  TP-3"
     git push -u origin main   