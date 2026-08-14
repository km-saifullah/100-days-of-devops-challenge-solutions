# Fix Redis Deployment on Kubernetes

## 1. What is the Challenge?

The objective is to fix an existing Redis application running on a Kubernetes cluster.

The Deployment name is:

```text
redis-deployment
```

The Redis Pod was not running because the existing Deployment contained configuration errors.

Two issues were found:

### Issue 1 — Incorrect Redis Image

The Deployment was using:

```text
redis:alpin
```

The correct image is:

```text
redis:alpine
```

### Issue 2 — Incorrect ConfigMap Name

The Deployment was trying to mount:

```text
redis-conig
```

Kubernetes reported:

```text
FailedMount
configmap "redis-conig" not found
```

The ConfigMap reference must be changed to the actual existing ConfigMap name.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Redis
- Kubernetes Deployment
- ConfigMap

# 3. How to Solve It

### Step 1

Check the Redis Deployment:

```bash
kubectl get deployment redis-deployment
```

### Step 2

Check the Pods:

```bash
kubectl get pods
```

The Redis Pod should not be in the `Running` state.

### Step 3

Inspect the Redis Pod:

```bash
kubectl describe pod <redis-pod-name>
```

The container showed:

```text
Image: redis:alpin
```

This image name contains a typo.

The Pod events also showed:

```text
FailedMount
configmap "redis-conig" not found
```

### Step 4

Check the available ConfigMaps:

```bash
kubectl get configmap
```

Find the actual Redis ConfigMap name.

For example:

```text
redis-config
```

### Step 5

Fix the Redis image:

```bash
kubectl set image deployment/redis-deployment \
  redis-container=redis:alpine
```

### Step 6

Verify the image:

```bash
kubectl get deployment redis-deployment \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Expected:

```text
redis:alpine
```

### Step 7

Edit the Deployment:

```bash
kubectl edit deployment redis-deployment
```

Find:

```yaml
configMap:
  name: redis-conig
```

Change it to the actual ConfigMap name.

For example, if the existing ConfigMap is `redis-config`:

```yaml
configMap:
  name: redis-config
```

Do not modify the other valid Deployment configuration.

### Step 8

Check the rollout:

```bash
kubectl rollout status deployment redis-deployment
```

Expected:

```text
deployment "redis-deployment" successfully rolled out
```

### Step 9

Check the Pod:

```bash
kubectl get pods
```

The Redis Pod should now be:

```text
READY   STATUS
1/1     Running
```

### Step 10

Verify the Redis image:

```bash
kubectl get deployment redis-deployment \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Expected:

```text
redis:alpine
```

### Step 11

Verify the ConfigMap reference:

```bash
kubectl get deployment redis-deployment \
  -o jsonpath='{.spec.template.spec.volumes[?(@.name=="config")].configMap.name}{"\n"}'
```

It should show the existing Redis ConfigMap name.

For example:

```text
redis-config
```

# 4. Main Takeaways

- The Redis image contained a typo.
- `redis:alpin` was changed to `redis:alpine`
- The Deployment referenced a ConfigMap named `redis-conig`
- Kubernetes could not find that ConfigMap, causing a `FailedMount` error
- The ConfigMap reference was changed to the correct existing ConfigMap
- The Deployment was rolled out again
- The Redis Pod was verified to be running

# 5. Conclusion

The Redis application was down because the Deployment contained two incorrect settings.

The first problem was the Redis image:

```text
redis:alpin
```

which was corrected to:

```text
redis:alpine
```

The second problem was the ConfigMap reference:

```text
redis-conig
```

which did not exist.

After changing it to the correct existing ConfigMap name, Kubernetes was able to mount the configuration successfully.

The final Redis Pod should be:

```text
READY   STATUS
1/1     Running
```
