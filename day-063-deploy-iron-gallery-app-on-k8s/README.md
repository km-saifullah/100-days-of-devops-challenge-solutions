# Deploy Iron Gallery Application on Kubernetes

## 1. What is the Challenge?

The objective is to deploy the **Iron Gallery** application and its MariaDB database on a Kubernetes cluster.

The application must run inside the namespace `iron-namespace-nautilus` with the required deployments, containers, volumes, resource limits, and services.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Namespace
- Deployment
- Service
- NodePort
- ClusterIP
- emptyDir Volume
- MariaDB
- Nginx

# 3. How to Solve It

### Step 1

Create the Kubernetes YAML file

```bash
vi iron-gallery.yaml
```

### Step 2

Create the namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: iron-namespace-nautilus
```

### Step 3

Create the Iron Gallery deployment.

The deployment uses

```text
kodekloud/irongallery:2.0
```

The container name is

```text
iron-gallery-container-nautilus
```

It uses one replica and the required label

```text
run=iron-gallery
```

The resource limits are

```text
Memory: 100Mi
CPU: 50m
```

Two `emptyDir` volumes are mounted

```text
config  -> /usr/share/nginx/html/data
images  -> /usr/share/nginx/html/uploads
```

### Step 4

Create the Iron DB deployment.

The deployment uses

```text
kodekloud/irondb:2.0
```

The container name is

```text
iron-db-container-nautilus
```

The required database environment variables are configured:

```text
MYSQL_DATABASE=database_host
MYSQL_USER=ironuser
```

The root and database passwords are also configured with complex values.

The database volume is

```text
db -> /var/lib/mysql
```

The volume uses `emptyDir`.

### Step 5

Create the database service.

The service is named

```text
iron-db-service-nautilus
```

### Step 6

Create the gallery service.

The service is named

```text
iron-gallery-service-nautilus
```

### Step 7

Apply the configuration

```bash
kubectl apply -f iron-gallery.yaml
```

### Step 8

Verify the deployments

```bash
kubectl get deployments -n iron-namespace-nautilus
```

Both deployments should have one available replica.

### Step 9

Verify the Pods

```bash
kubectl get pods -n iron-namespace-nautilus
```

Expected state

```text
1/1   Running
```

### Step 10

Verify the services

```bash
kubectl get services -n iron-namespace-nautilus
```

# 4. Main Takeaways

- Kubernetes namespaces provide isolation for application resources
- Deployments manage the required application and database Pods
- `emptyDir` provides temporary shared storage for the containers
- Resource limits can control CPU and memory usage
- ClusterIP is suitable for internal database communication
- NodePort exposes the gallery application outside the cluster
- Exact deployment, container, volume, and service names should be maintained according to the requirements

# 5. Conclusion

The required Iron Gallery application resources were created successfully in the specified namespace. The deployments, volumes, and services were configured according to the requirements and verified to ensure the application is running correctly.
