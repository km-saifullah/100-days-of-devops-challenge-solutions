# Create an HTTPD Pod with Resource Requests and Limits

## 1. What is the Challenge?

The objective is to create a Kubernetes Pod with resource requests and limits.

The Pod must have:

- Pod name: **httpd-pod**
- Container name: **httpd-container**
- Image: **httpd:latest**

### Resource Requests

```text
Memory: 15Mi
CPU:    100m
```

### Resource Limits

```text
Memory: 20Mi
CPU:    100m
```

The `kubectl` utility is already configured on the **jump-host**.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- YAML
- HTTPD

# 3. How to Solve It

### Step 1

SSH into the jump-host.

```bash
ssh thor@jump-host
```

### Step 2

Create the Pod YAML file.

```bash
vi httpd-pod.yaml
```

Add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
      resources:
        requests:
          memory: "15Mi"
          cpu: "100m"
        limits:
          memory: "20Mi"
          cpu: "100m"
```

### Step 3

Create the Pod.

```bash
kubectl apply -f httpd-pod.yaml
```

Expected output:

```text
pod/httpd-pod created
```

### Step 4

Verify the Pod.

```bash
kubectl get pod httpd-pod
```

The Pod should eventually show:

```text
NAME        READY   STATUS    RESTARTS   AGE
httpd-pod   1/1     Running   0          ...
```

### Step 5

Verify the container name and resources.

```bash
kubectl describe pod httpd-pod
```

Check that the container is:

```text
httpd-container
```

and the image is:

```text
httpd:latest
```

The resource configuration should be:

```text
Requests:
  cpu:     100m
  memory:  15Mi

Limits:
  cpu:     100m
  memory:  20Mi
```

# 4. Main Takeaways

- Learned how to create a Kubernetes Pod using a YAML file
- Configured CPU and memory resource requests
- Configured CPU and memory resource limits
- Used the explicitly specified `httpd:latest` image
- Verified the Pod configuration using `kubectl describe`

# 5. Conclusion

This task demonstrates how Kubernetes resource requests and limits can be configured at the **container level**. Requests define the resources needed by the container, while limits define the maximum resources the container can consume.
