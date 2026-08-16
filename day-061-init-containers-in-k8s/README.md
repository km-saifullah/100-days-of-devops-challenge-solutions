# Create Kubernetes Deployment with Init Container

## 1. What is the Challenge?

The objective is to create a Kubernetes Deployment that uses an **init container** to perform a task before the main application container starts.

The init container creates a file inside a shared volume, and the main container continuously reads that file.

The Deployment must use the exact names and configurations provided in the requirements.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Deployment
- Init Container
- Ubuntu Image

# 3. How to Solve It

### Step 1

Create the Deployment YAML file

```bash
vi ic-deploy-datacenter.yaml
```

### Step 2

Add the following configuration

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-datacenter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-datacenter
  template:
    metadata:
      labels:
        app: ic-datacenter
    spec:
      initContainers:
        - name: ic-msg-datacenter
          image: ubuntu:latest
          command:
            - /bin/bash
            - -c
            - echo Init Done - Welcome to xFusionCorp Industries > /ic/ecommerce
          volumeMounts:
            - name: ic-volume-datacenter
              mountPath: /ic

      containers:
        - name: ic-main-datacenter
          image: ubuntu:latest
          command:
            - /bin/bash
            - -c
            - while true; do cat /ic/ecommerce; sleep 5; done
          volumeMounts:
            - name: ic-volume-datacenter
              mountPath: /ic

      volumes:
        - name: ic-volume-datacenter
          emptyDir: {}
```

### Step 3

Create the Deployment

```bash
kubectl apply -f ic-deploy-datacenter.yaml
```

### Step 4

Check the Deployment

```bash
kubectl get deployment ic-deploy-datacenter
```

Expected Output

```text
READY   UP-TO-DATE   AVAILABLE
1/1     1            1
```

### Step 5

Check the Pod:

```bash
kubectl get pods -l app=ic-datacenter
```

The Pod should be running

```text
READY   STATUS
1/1     Running
```

### Step 6

Verify the main container output

```bash
kubectl logs deployment/ic-deploy-datacenter -c ic-main-datacenter
```

Expected output

```text
Init Done - Welcome to xFusionCorp Industries
```

# 4. Main Takeaways

- Init containers run before the main container
- The init container creates the required file before the application starts
- Both containers share the same `emptyDir` volume
- The exact container names, image tags, commands, and volume names are maintained
- The Deployment uses one replica as required

# 5. Conclusion

The required Kubernetes Deployment was created successfully with an init container and a shared volume. The Deployment and Pod were verified to ensure the required configuration is working as expected.
