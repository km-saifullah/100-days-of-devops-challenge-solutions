# Deploy Grafana on Kubernetes with NodePort

## 1. What is the Challenge?

The objective is to deploy **Grafana** on a Kubernetes cluster and expose it using a **NodePort** service.

The Deployment must be named:

```text
grafana-deployment-nautilus
```

The Grafana application should use a Grafana image and be accessible through NodePort: 32000

No additional Grafana configuration is required. The main requirement is to make sure the Grafana login page is accessible.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Grafana
- Kubernetes Deployment
- Kubernetes NodePort Service

# 3. How to Solve It

### Step 1

Create the Kubernetes YAML file:

```bash
vi grafana.yaml
```

Add:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana
          image: grafana/grafana:latest
          ports:
            - containerPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: grafana-service
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```

### Step 2

Create the Deployment and Service:

```bash
kubectl apply -f grafana.yaml
```

Expected:

```text
deployment.apps/grafana-deployment-nautilus created
service/grafana-service created
```

### Step 3

Check the Deployment:

```bash
kubectl get deployment grafana-deployment-nautilus
```

The Deployment should show:

```text
READY   1/1
```

### Step 4

Check the Grafana Pod:

```bash
kubectl get pods -l app=grafana
```

The Pod should be:

```text
Running
```

### Step 5

Check the Service:

```bash
kubectl get service grafana-service
```

The Service should show:

```text
TYPE       NodePort
```

### Step 6

Verify the Deployment image:

```bash
kubectl get deployment grafana-deployment-nautilus \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Expected:

```text
grafana/grafana:latest
```

### Step 7

Access Grafana.

Use the node IP with port `32000`:

```text
http://<node-ip>:32000
```

The Grafana login page should be accessible.

# 4. Main Takeaways

- Learned how to deploy Grafana on Kubernetes
- Created a Deployment named `grafana-deployment-nautilus`
- Used the Grafana image `grafana/grafana:latest`
- Exposed Grafana's port `3000`
- Created a NodePort Service
- Used NodePort `32000`
- Verified that the Grafana login page is accessible

# 5. Conclusion

The final Kubernetes setup contains:

```text
Deployment:
grafana-deployment-nautilus
```

```text
Image:
grafana/grafana:latest
```

```text
Container Port:
3000
```

```text
Service:
grafana-service
```

```text
Service Type:
NodePort
```

```text
NodePort:
32000
```

Grafana can be accessed using:

```text
http://<node-ip>:32000
```
