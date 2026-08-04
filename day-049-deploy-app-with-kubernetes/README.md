# Create an Nginx Deployment in Kubernetes

## 1. What is the Challenge?

The objective is to create a Kubernetes **Deployment** with the following requirements:

- Deployment name: **nginx**
- Application: **nginx**
- Image: **nginx:latest**
- The image tag must be explicitly specified as `latest`

The `kubectl` utility is already configured on the **jump-host**.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- Nginx

# 3. How to Solve It

### Step 1

SSH into the jump-host.

```bash
ssh thor@jump-host
```

### Step 2

Create the Nginx deployment.

```bash
kubectl create deployment nginx --image=nginx:latest
```

This creates a Deployment named:

```text
nginx
```

using:

```text
nginx:latest
```

### Step 3

Verify the Deployment.

```bash
kubectl get deployments
```

Expected output:

```text
NAME    READY   UP-TO-DATE   AVAILABLE
nginx   1/1     1            1
```

### Step 4

Check the Pod created by the Deployment.

```bash
kubectl get pods
```

The Pod should be in the **Running** state.

### Step 5

Verify the image.

```bash
kubectl describe deployment nginx
```

Look for:

```text
Image: nginx:latest
```

# 4. Main Takeaways

- Learned how to create a Kubernetes Deployment
- Used the `nginx:latest` image
- Learned that a Deployment manages Pods
- Used `kubectl` to create and verify the Deployment

# 5. Conclusion

This task demonstrates how to create a basic Kubernetes Deployment using the Nginx image. The Deployment named **nginx** manages an Nginx Pod running the explicitly specified **nginx:latest** image.
