# Deploy Redis on Kubernetes

## 1. What is the Challenge?

The objective is to deploy Redis on the Kubernetes cluster for in-memory caching.

A ConfigMap is required to configure Redis with a maximum memory limit of `2mb`. The Redis application should run with one replica and use the required volumes and CPU request.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- ConfigMap
- Deployment
- Redis
- emptyDir Volume

# 3. How to Solve It

### Step 1

Create a YAML file

```bash
vi redis.yaml
```

### Step 2

Create the ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-redis-config
data:
  redis-config: |
    maxmemory 2mb
```

### Step 3

Create the Redis Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          resources:
            requests:
              cpu: "1"
          ports:
            - containerPort: 6379
          volumeMounts:
            - name: data
              mountPath: /redis-master-data
            - name: redis-config
              mountPath: /redis-master
      volumes:
        - name: data
          emptyDir: {}
        - name: redis-config
          configMap:
            name: my-redis-config
```

### Step 4

Apply the configuration

```bash
kubectl apply -f redis.yaml
```

### Step 5

Verify the ConfigMap

```bash
kubectl get configmap my-redis-config
```

### Step 6

Verify the Deployment

```bash
kubectl get deployment redis-deployment
```

### Step 7

Check the Redis Pod

```bash
kubectl get pods
```

### Step 8

Verify the Redis configuration

```bash
kubectl exec -it deploy/redis-deployment \
  -c redis-container -- cat /redis-master/redis-config
```

# 4. Main Takeaways

- ConfigMaps can be used to provide application configuration to Kubernetes containers
- Redis is deployed using the `redis:alpine` image
- The Deployment uses exactly one replica
- The Redis container requests one CPU
- An `emptyDir` volume is mounted at `/redis-master-data`
- The ConfigMap volume is mounted at `/redis-master`
- Redis exposes port `6379`

# 5. Conclusion

The Redis Deployment and ConfigMap were created according to the given requirements. Redis is configured with the required `2mb` maximum memory setting, one replica, the required CPU request, and both required volumes.

The final Pod should be in the `Running` state.
