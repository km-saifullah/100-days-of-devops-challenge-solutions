# Nginx Sidecar Container for Log Shipping

## 1. What is the Challenge?

The objective is to create a Kubernetes Pod using the **Sidecar pattern**.

The Pod must be named:

```text
webserver
```

The Pod must contain:

```text
nginx-container
sidecar-container
```

The Nginx container uses:

```text
nginx:latest
```

The sidecar uses:

```text
ubuntu:latest
```

The sidecar must be configured as an **init container** and continuously read the Nginx access and error logs.

A shared `emptyDir` volume named:

```text
shared-logs
```

must be mounted at:

```text
/var/log/nginx
```

in both containers.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Nginx
- Ubuntu
- emptyDir Volume
- Sidecar Container Pattern

# 3. How to Solve It

### Step 1

Create the YAML file:

```bash
vi webserver.yaml
```

Use the following configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

  initContainers:
    - name: sidecar-container
      image: ubuntu:latest
      restartPolicy: Always
      command:
        - sh
        - -c
        - while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

  volumes:
    - name: shared-logs
      emptyDir: {}
```

### Step 2

Create the Pod:

```bash
kubectl apply -f webserver.yaml
```

### Step 3

Check the Pod:

```bash
kubectl get pod webserver
```

Expected:

```text
NAME        READY   STATUS    RESTARTS   AGE
webserver   2/2     Running   0          ...
```

### Step 4

Verify the Nginx container:

```bash
kubectl get pod webserver \
  -o jsonpath='{.spec.containers[*].name}{"\n"}'
```

Expected:

```text
nginx-container
```

Verify the sidecar init container:

```bash
kubectl get pod webserver \
  -o jsonpath='{.spec.initContainers[*].name}{"\n"}'
```

Expected:

```text
sidecar-container
```

### Step 5

Verify the sidecar image:

```bash
kubectl get pod webserver \
  -o jsonpath='{.spec.initContainers[*].image}{"\n"}'
```

Expected:

```text
ubuntu:latest
```

### Step 6

Verify the shared volume:

```bash
kubectl describe pod webserver
```

The volume should be:

```text
shared-logs
```

and its type should be:

```text
EmptyDir
```

Both containers should have:

```text
/var/log/nginx
```

mounted.

### Step 7

Check the sidecar logs:

```bash
kubectl logs webserver -c sidecar-container
```

The sidecar executes:

```text
while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done
```

# 4. Important Kubernetes Detail

The requirement specifically calls `sidecar-container` an **init container**.

Therefore, it must be placed under:

```yaml
initContainers:
```

and not under:

```yaml
containers:
```

Because the sidecar must continue running, it uses:

```yaml
restartPolicy: Always
```

This allows the init container to behave as a long-running sidecar.

The final structure is:

```text
webserver
│
├── nginx-container
│   └── nginx:latest
│
└── sidecar-container
    └── ubuntu:latest
        restartPolicy: Always
```

Both containers share:

```text
shared-logs
```

# 5. Main Takeaways

- Learned how to create a Kubernetes Pod with an Nginx container
- Learned how to configure a sidecar-style init container
- Used the exact container names required by the task
- Used `nginx:latest` for the Nginx container
- Used `ubuntu:latest` for the sidecar container
- Used an `emptyDir` volume to share Nginx logs
- Mounted the shared volume at `/var/log/nginx`
- Used `restartPolicy: Always` for the long-running sidecar init container

# 6. Conclusion

The final Pod configuration is:

```text
Pod:
webserver
```

```text
Regular Container:
nginx-container

Image:
nginx:latest
```

```text
Init Sidecar Container:
sidecar-container

Image:
ubuntu:latest

Restart Policy:
Always
```

```text
Shared Volume:
shared-logs

Type:
emptyDir

Mount:
 /var/log/nginx
```

Both containers should remain operational:

```text
READY: 2/2
STATUS: Running
```
