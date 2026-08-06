# Rolling Update of Nginx Deployment

## 1. What is the Challenge?

The objective is to perform a **rolling update** on the existing Kubernetes Deployment.

The Deployment name is:

```text
nginx-deployment
```

The new Nginx image is:

```text
nginx:1.17
```

The existing container name is:

```text
nginx-container
```

The requirements are:

- Update the existing `nginx-deployment`
- Use the image `nginx:1.17`
- Perform a rolling update
- Do not delete the Deployment
- Make sure all Pods are operational after the update

The `kubectl` utility is already configured on the **jump-host**.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- Nginx
- Kubernetes Rolling Update

# 3. How to Solve It

### Step 1

SSH into the jump-host.

```bash
ssh thor@jump-host
```

### Step 2

Check the existing Deployment.

```bash
kubectl get deployment nginx-deployment
```

### Step 3

Verify the exact container name.

```bash
kubectl get deployment nginx-deployment \
  -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

The container name is:

```text
nginx-container
```

### Step 4

Update the image.

Because the container name is `nginx-container`, use:

```bash
kubectl set image deployment/nginx-deployment \
  nginx-container=nginx:1.17
```

Kubernetes will perform a rolling update and gradually replace the old Pods with new Pods running the `nginx:1.17` image.

### Step 5

Monitor the rolling update.

```bash
kubectl rollout status deployment/nginx-deployment
```

A successful update should show:

```text
deployment "nginx-deployment" successfully rolled out
```

### Step 6

Check all Pods.

```bash
kubectl get pods
```

Make sure the Pods are:

```text
Running
```

and the `READY` column shows:

```text
1/1
```

### Step 7

Verify the new image.

```bash
kubectl describe deployment nginx-deployment
```

Check that the container is:

```text
nginx-container
```

and the image is:

```text
nginx:1.17
```

# 4. Main Takeaways

- Learned how to perform a Kubernetes rolling update
- Updated an existing Deployment without deleting it
- Used the exact container name `nginx-container`
- Updated the image from the existing version to `nginx:1.17`
- Used `kubectl rollout status` to monitor the update
- Verified that all Pods are running after the update

# 5. Conclusion

This task demonstrates how Kubernetes performs a **rolling update**.

The existing Deployment:

```text
nginx-deployment
```

is updated using:

```text
nginx:1.17
```

with the exact container name:

```text
nginx-container
```

Kubernetes gradually replaces the old Pods with new Pods, allowing the application to remain available during the update.
