# Create an Nginx Pod in Kubernetes

## 1. What is the Challenge?

The objective is to create a Kubernetes **Pod** on the cluster with the following requirements:

- Pod name: **pod-nginx**
- Image: **nginx:latest**
- Label:
  - `app=nginx_app`
- Container name:
  - **nginx-container**

The `kubectl` command-line tool is already configured on the **jump-host**.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- YAML

# 3. How to Solve It

### Step 1

SSH into the **jump-host**.

```bash
ssh thor@jump-host
```

### Step 2

Create a Pod manifest.

```bash
vi pod.yaml
```

Add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx_app
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
```

### Step 3

Create the Pod.

```bash
kubectl apply -f pod.yaml
```

### Step 4

Verify the Pod.

```bash
kubectl get pods
```

Expected output:

```text
NAME         READY   STATUS    RESTARTS   AGE
pod-nginx    1/1     Running   0          10s
```

### Step 5

View detailed information.

```bash
kubectl describe pod pod-nginx
```

Verify the following:

- Pod Name:

```text
pod-nginx
```

- Container Name:

```text
nginx-container
```

- Image:

```text
nginx:latest
```

- Label:

```text
app=nginx_app
```

# 4. Main Takeaways

- Learned how to create a Kubernetes Pod using a YAML manifest
- Assigned custom labels to the Pod
- Used the **nginx:latest** image
- Set the container name exactly as required
- Verified the Pod using `kubectl`

# 5. Conclusion

This task demonstrates how to deploy a simple Kubernetes Pod using a YAML manifest. By specifying the Pod name, container name, image, and labels, the Pod can be deployed consistently and managed easily within the Kubernetes cluster.
