# Create Kubernetes Secret and Mount It in a Pod

## 1. What is the Challenge?

The objective is to securely store the license/password information from `/opt/media.txt` in a Kubernetes Secret and make it available inside a Pod.

The Secret must be named `media`, and the Pod must be named `secret-xfusion`.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Kubernetes Secret
- Pod
- Fedora

# 3. How to Solve It

### Step 1

Create the Secret from the existing file

```bash
kubectl create secret generic media --from-file=/opt/media.txt
```

This creates a generic Secret named

```text
media
```

### Step 2

Verify the Secret

```bash
kubectl get secret media
```

### Step 3

Create the Pod YAML file

```bash
vi secret-xfusion.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-xfusion
spec:
  containers:
    - name: secret-container-xfusion
      image: fedora:latest
      command:
        - /bin/bash
        - -c
        - sleep infinity
      volumeMounts:
        - name: media-secret
          mountPath: /opt/games
          readOnly: true

  volumes:
    - name: media-secret
      secret:
        secretName: media
```

### Step 4

Create the Pod

```bash
kubectl apply -f secret-xfusion.yaml
```

### Step 5

Check the Pod status

```bash
kubectl get pod secret-xfusion
```

Expected Output

```text
READY   STATUS
1/1     Running
```

### Step 6

Check the mounted Secret

```bash
kubectl exec -it secret-xfusion \
  -c secret-container-xfusion -- ls -l /opt/games
```

The Secret file should be available

```text
media.txt
```

### Step 7

Verify the file content

```bash
kubectl exec -it secret-xfusion \
  -c secret-container-xfusion -- cat /opt/games/media.txt
```

The content should match the original `/opt/media.txt` file.

# 4. Main Takeaways

- Kubernetes Secrets can securely store sensitive information
- A Secret can be created directly from an existing file
- Secrets can be mounted into containers as files
- The Secret is mounted at `/opt/games`
- The container is kept running using the sleep command
- The required Secret, Pod, container, and image names are maintained exactly

# 5. Conclusion

The Kubernetes Secret and Pod were created successfully according to the given requirements. The Secret was mounted into the container and verified to ensure the required file is available.
