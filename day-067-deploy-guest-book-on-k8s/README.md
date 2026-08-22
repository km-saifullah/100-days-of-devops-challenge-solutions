# Deploy Guestbook Application on Kubernetes

## 1. What is the Challenge?

The objective is to deploy the Guestbook application on a Kubernetes cluster.

The application consists of a Redis back-end tier and a PHP frontend tier.

The Redis back-end contains:

- Redis master
- Redis slaves
- Redis master service
- Redis slave service
- Redis follower service

The frontend contains three replicas and is exposed externally using a NodePort Service.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Deployment
- Service
- NodePort
- Redis
- Guestbook frontend

# 3. Back-End Tier

## Redis Master

Deployment

```text
redis-master
```

Replicas

```text
1
```

Container

```text
master-redis-nautilus
```

Image

```text
redis
```

Resource requests

```text
CPU:    100m
Memory: 100Mi
```

Container port

```text
6379
```

## Redis Master Service

Service

```text
redis-master
```

Port

```text
6379
```

TargetPort

```text
6379
```

## Redis Slave

Deployment

```text
redis-slave
```

Replicas

```text
2
```

Container

```text
slave-redis-nautilus
```

Image

```text
gcr.io/google_samples/gb-redisslave:v3
```

Resource requests

```text
CPU:    100m
Memory: 100Mi
```

Environment variable

```text
GET_HOSTS_FROM=dns
```

Container port

```text
6379
```

## Redis Slave Service

Service

```text
redis-slave
```

Port

```text
6379
```

TargetPort

```text
6379
```

## Redis Follower Service

Service

```text
redis-follower
```

Selector

```text
app=redis-slave
```

Port

```text
6379
```

TargetPort

```text
6379
```

# 4. Frontend Tier

## Frontend Deployment

Deployment

```text
frontend
```

Replicas

```text
3
```

Container

```text
php-redis-nautilus
```

Image:

```text
gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff
```

Resource requests

```text
CPU:    100m
Memory: 100Mi
```

Environment variable

```text
GET_HOSTS_FROM=dns
```

Container port

```text
80
```

---

# 5. Frontend Service

Service

```text
frontend
```

Service type

```text
NodePort
```

Port

```text
80
```

TargetPort

```text
80
```

NodePort

```text
30009
```

# 6. How to Solve It

### Step 1

Create the Kubernetes manifest

```bash
vi guestbook.yaml
```

### Step 2

Add the Redis master Deployment and Service.

The master Deployment uses one replica and the required Redis image:

```yaml
image: redis
```

The container is named

```text
master-redis-nautilus
```

### Step 3

Create the Redis slave Deployment.

The Deployment uses two replicas and

```text
gcr.io/google_samples/gb-redisslave:v3
```

The container is named

```text
slave-redis-nautilus
```

Configure

```text
GET_HOSTS_FROM=dns
```

### Step 4

Create the Redis Services

```text
redis-master
redis-slave
redis-follower
```

The `redis-follower` Service selects the Redis slave Pods using:

```text
app=redis-slave
```

### Step 5

Create the frontend Deployment.

The frontend uses three replicas and the required image.

The container is named

```text
php-redis-nautilus
```

Configure

```text
GET_HOSTS_FROM=dns
```

### Step 6

Create the frontend NodePort Service.

The Service is named

```text
frontend
```

### Step 7

Apply the complete configuration

```bash
kubectl apply -f guestbook.yaml
```

# 7. Verify the Deployment

Check all Deployments

```bash
kubectl get deployments
```

Expected output

```text
redis-master   1/1
redis-slave    2/2
frontend       3/3
```

Check the Pods

```bash
kubectl get pods
```

# 8. Verify the Services

Run

```bash
kubectl get svc
```

The following Services should exist

```text
redis-master
redis-slave
redis-follower
frontend
```

# 9. Verify the Final Setup

Run

```bash
kubectl get pods,deployments,svc
```

Make sure

- Redis master has 1 running Pod
- Redis slave has 2 running Pods
- Frontend has 3 running Pods
- Redis Services are available on port 6379
- Frontend is exposed through NodePort 30009

# 10. Test the Application

Once all Pods are running, use the **App** button provided by the KodeKloud environment to access the Guestbook application.

# 11. Main Takeaways

- Kubernetes Deployments can maintain the required number of application replicas
- Redis master and slave Pods provide the back-end tier for the Guestbook application
- Services provide stable networking between application components
- The frontend uses three replicas for availability and scalability
- A NodePort Service exposes the frontend outside the Kubernetes cluster
- The required frontend NodePort is `30009`

# 12. Conclusion

The Guestbook application was deployed on Kubernetes with the required Redis back-end and frontend components.

The Redis master, Redis slave replicas, internal Services, frontend replicas, and NodePort Service were configured according to the requirements.

After verifying that all Pods are running and the frontend Service is available on NodePort `30009`, the Guestbook application can be accessed using the App button.
