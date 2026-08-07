# Rollback Nginx Deployment to Previous Revision

## 1. What is the Challenge?

The objective is to roll back the Kubernetes Deployment to its **previous revision** because the latest application release has a reported bug.

The Deployment name is:

```text
nginx-deployment
```

The requirement is to:

- Roll back to the previous revision
- Make sure the rollback completes successfully
- Verify that all Pods are operational

The `kubectl` utility is already configured on the **jump-host**.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- Kubernetes Deployment
- Rollout

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

Check the Deployment revision history.

```bash
kubectl rollout history deployment/nginx-deployment
```

This allows you to see the available Deployment revisions.

### Step 4

Roll back to the previous revision.

```bash
kubectl rollout undo deployment/nginx-deployment
```

The command rolls the Deployment back by one revision.

### Step 5

Monitor the rollback.

```bash
kubectl rollout status deployment/nginx-deployment
```

A successful rollback should show:

```text
deployment "nginx-deployment" successfully rolled out
```

### Step 6

Verify the Pods.

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

Verify the rollout history.

```bash
kubectl rollout history deployment/nginx-deployment
```

This confirms that the Deployment revision history has been updated after the rollback.

# 4. Main Takeaways

- Learned how to check Kubernetes Deployment revision history
- Learned how to roll back a Deployment
- Used `kubectl rollout undo` to return to the previous revision
- Used `kubectl rollout status` to monitor the rollback
- Verified that the application Pods are operational after the rollback

# 5. Conclusion

This task demonstrates how Kubernetes can quickly roll back a Deployment when a newly released version causes problems.

The Deployment:

```text
nginx-deployment
```

is rolled back using:

```bash
kubectl rollout undo deployment/nginx-deployment
```

After the rollback, the Pods should be running normally with the previous application revision.
