# Create Persistent Volume, PVC and Nginx Pod on Kubernetes

## 1. What is the Challenge?

The objective is to create persistent storage for a web application and deploy an Nginx web server using that storage.

The task requires:

- Creating a PersistentVolume named `pv-devops`
- Creating a PersistentVolumeClaim named `pvc-devops`
- Creating a Pod named `pod-devops`
- Using the container name `container-devops`
- Using the image `nginx:latest`
- Mounting the PVC at the Nginx document root
- Creating a NodePort Service named `web-devops`
- Using NodePort `30008`

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- PersistentVolume
- PersistentVolumeClaim
- Nginx
- NodePort Service
- hostPath

# 3. How to Solve It

### Step 1

Create the Kubernetes YAML file:

```bash
vi pv-pvc-pod-service.yaml
```

### Step 2

Create the PersistentVolume:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-devops
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/sysops
```

The PV provides `5Gi` of storage using the existing `/mnt/sysops` host path.

### Step 3

Create the PersistentVolumeClaim:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-devops
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

The PVC requests `3Gi` from the `pv-devops` PersistentVolume.

### Step 4

Create the Nginx Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-devops
  labels:
    app: devops
spec:
  containers:
    - name: container-devops
      image: nginx:latest
      ports:
        - containerPort: 80
      volumeMounts:
        - name: devops-volume
          mountPath: /usr/share/nginx/html
  volumes:
    - name: devops-volume
      persistentVolumeClaim:
        claimName: pvc-devops
```

The PVC is mounted at the Nginx document root:

```text
/usr/share/nginx/html
```

### Step 5

Create the NodePort Service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-devops
spec:
  type: NodePort
  selector:
    app: devops
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
```

The service exposes the Nginx Pod through NodePort `30008`.

### Step 6

Apply the complete configuration:

```bash
kubectl apply -f pv-pvc-pod-service.yaml
```

### Step 7

Check the PersistentVolume:

```bash
kubectl get pv pv-devops
```

Expected:

```text
STATUS   Bound
```

### Step 8

Check the PersistentVolumeClaim:

```bash
kubectl get pvc pvc-devops
```

Expected:

```text
STATUS   Bound
```

### Step 9

Check the Pod:

```bash
kubectl get pod pod-devops
```

Expected:

```text
READY   STATUS
1/1     Running
```

### Step 10

Check the Service:

```bash
kubectl get service web-devops
```

The service should show:

```text
80:30008/TCP
```

# 4. Main Takeaways

- A PersistentVolume provides storage to Kubernetes workloads
- A PersistentVolumeClaim requests storage from a PersistentVolume
- The `manual` storage class connects the PV and PVC
- The PV provides `5Gi`, while the PVC requests `3Gi`
- The Nginx container uses the exact image `nginx:latest`
- The PVC is mounted at the Nginx document root
- A NodePort Service exposes the Nginx application on port `30008`

# 5. Conclusion

The required Kubernetes resources were created and configured successfully according to the given requirements. The deployment and service were verified to ensure everything is working as expected.
