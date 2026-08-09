# Share an EmptyDir Volume Between Kubernetes Containers

## 1. What is the Challenge?

The objective is to create a Kubernetes Pod containing two Fedora containers that share the same volume.

The required Pod name is:

```text
volume-share-xfusion
```

The two containers must use the exact names:

```text
volume-container-xfusion-1
volume-container-xfusion-2
```

Both containers must use:

```text
fedora:latest
```

The shared volume must be named:

```text
volume-share
```

and must use the:

```text
emptyDir
```

volume type.

The first container mounts the volume at:

```text
/tmp/blog
```

The second container mounts the same volume at:

```text
/tmp/cluster
```

A test file must be created in the first container and verified from the second container.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- YAML
- Fedora
- emptyDir Volume

# 3. How to Solve It

### Step 1

SSH into the jump host.

```bash
ssh thor@jump-host
```

### Step 2

Create the Pod YAML file.

```bash
vi volume-share-xfusion.yaml
```

Add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-xfusion
spec:
  containers:
    - name: volume-container-xfusion-1
      image: fedora:latest
      command: ["sleep", "infinity"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/blog

    - name: volume-container-xfusion-2
      image: fedora:latest
      command: ["sleep", "infinity"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/cluster

  volumes:
    - name: volume-share
      emptyDir: {}
```

### Step 3

Create the Pod.

```bash
kubectl apply -f volume-share-xfusion.yaml
```

Expected:

```text
pod/volume-share-xfusion created
```

### Step 4

Verify the Pod.

```bash
kubectl get pod volume-share-xfusion
```

Expected:

```text
NAME                  READY   STATUS    RESTARTS   AGE
volume-share-xfusion  2/2     Running   0          ...
```

Both containers should be running.

### Step 5

Create `blog.txt` inside the first container.

```bash
kubectl exec volume-share-xfusion \
  -c volume-container-xfusion-1 \
  -- sh -c 'echo "Welcome to xFusionCorp Industries" > /tmp/blog/blog.txt'
```

The file is created at:

```text
/tmp/blog/blog.txt
```

### Step 6

Verify the file from the first container.

```bash
kubectl exec volume-share-xfusion \
  -c volume-container-xfusion-1 \
  -- cat /tmp/blog/blog.txt
```

Expected:

```text
Welcome to xFusionCorp Industries
```

### Step 7

Verify the same file from the second container.

```bash
kubectl exec volume-share-xfusion \
  -c volume-container-xfusion-2 \
  -- cat /tmp/cluster/blog.txt
```

Expected:

```text
Welcome to xFusionCorp Industries
```

The file is available because both containers mount the same `volume-share` volume.

### Step 8

You can verify the volume configuration with:

```bash
kubectl describe pod volume-share-xfusion
```

You should see:

```text
volume-share
```

with:

```text
Type: EmptyDir
```

The mounts should be:

```text
volume-container-xfusion-1
    /tmp/blog

volume-container-xfusion-2
    /tmp/cluster
```

# 4. Main Takeaways

- Learned how to create multiple containers inside a Kubernetes Pod
- Learned how to use an `emptyDir` volume
- Mounted the same volume into two different containers
- Used different mount paths for the same shared volume
- Verified that a file created in one container is accessible from another container
- Used `sleep infinity` to keep both Fedora containers running

# 5. Conclusion

This task demonstrates how multiple containers inside the same Kubernetes Pod can share temporary data using an `emptyDir` volume.

The final configuration is:

```text
Pod:
volume-share-xfusion
```

```text
Container 1:
volume-container-xfusion-1

Image:
fedora:latest

Mount:
volume-share -> /tmp/blog
```

```text
Container 2:
volume-container-xfusion-2

Image:
fedora:latest

Mount:
volume-share -> /tmp/cluster
```

```text
Volume:
volume-share

Type:
emptyDir
```

The test file:

```text
/tmp/blog/blog.txt
```

is also available as:

```text
/tmp/cluster/blog.txt
```

because both containers share the same `emptyDir` volume.
