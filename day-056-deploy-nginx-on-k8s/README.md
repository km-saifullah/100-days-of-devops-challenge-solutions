# Deploy Nginx with 3 Replicas and NodePort Service

## 1. What is the Challenge?

The objective is to deploy a highly available and scalable static website using Kubernetes.

The Deployment must be named:

```text
nginx-deployment
```

The Deployment requirements are:

- Use `nginx:latest`
- Container name must be `nginx-container`
- Replica count must be `3`

A NodePort Service must also be created.

The Service must be named:

```text
nginx-service
```

The Service type must be:

```text
NodePort
```

The required NodePort is:

```text
30011
```

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Nginx
- Kubernetes Deployment
- Kubernetes Service
- NodePort

# 3. How to Solve It

### Step 1

Create the Kubernetes YAML file.

```bash
vi nginx-deployment.yaml
```

Add:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
```

### Step 2

Create the Deployment and Service.

```bash
kubectl apply -f nginx-deployment.yaml
```

Expected:

```text
deployment.apps/nginx-deployment created
service/nginx-service created
```

### Step 3

Check the Deployment.

```bash
kubectl get deployment nginx-deployment
```

The Deployment should show:

```text
READY   3/3
```

### Step 4

Check the Pods.

```bash
kubectl get pods -l app=nginx
```

There should be exactly **3 Pods**.

All Pods should be:

```text
Running
```

and:

```text
READY
1/1
```

### Step 5

Check the Service.

```bash
kubectl get service nginx-service
```

The Service should show:

```text
TYPE       NodePort
```

and:

```text
80:30011/TCP
```

### Step 6

Verify the exact container name and image.

```bash
kubectl get deployment nginx-deployment \
  -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

Expected:

```text
nginx-container
```

Check the image:

```bash
kubectl get deployment nginx-deployment \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Expected:

```text
nginx:latest
```

# 4. Main Takeaways

- Learned how to create a Kubernetes Deployment
- Created 3 Nginx replicas for availability and scalability
- Used the exact image `nginx:latest`
- Used the exact container name `nginx-container`
- Created a NodePort Service named `nginx-service`
- Exposed the application using NodePort `30011`
- Used labels and selectors to connect the Service with the Deployment Pods

# 5. Conclusion

The final Kubernetes setup contains:

```text
Deployment:
nginx-deployment
```

```text
Image:
nginx:latest
```

```text
Container:
nginx-container
```

```text
Replicas:
3
```

```text
Service:
nginx-service
```

```text
Service Type:
NodePort
```

```text
NodePort:
30011
```

The Service sends traffic to port `80` of the Nginx containers through NodePort `30011`.
