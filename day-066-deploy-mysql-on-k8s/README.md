# Deploy MySQL on Kubernetes

## 1. What is the Challenge?

The objective is to deploy a MySQL database on a Kubernetes cluster with persistent storage, Kubernetes Secrets, a Deployment, and a NodePort Service.

The MySQL data should be stored using a PersistentVolume and PersistentVolumeClaim, while the database credentials and configuration should be provided through Kubernetes Secrets.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- PersistentVolume
- PersistentVolumeClaim
- Deployment
- Service
- NodePort
- Secrets
- MySQL

# 3. How to Solve It

### Step 1

Create a Kubernetes YAML file:

```bash
vi mysql.yaml
```

### Step 2

Create the PersistentVolume.

The PV is named

```text
mysql-pv
```

It provides

```text
250Mi
```

of storage with `ReadWriteOnce` access.

The storage class is

```text
manual
```

The volume uses a hostPath

```text
/mnt/data/mysql
```

---

### Step 3

Create the PersistentVolumeClaim.

The PVC is named

```text
mysql-pv-claim
```

It uses the `manual` storage class and `ReadWriteOnce` access mode.

### Step 4

Create the MySQL Secrets.

Root password Secret

```text
mysql-root-pass
```

Key

```text
password
```

Value

```text
YUIidhb667
```

---

User credentials Secret

```text
mysql-user-pass
```

Keys

```text
username
password
```

Values

```text
username: kodekloud_top
password: ksH85UJjhb
```

---

Database Secret:

```text
mysql-db-url
```

Key:

```text
database
```

Value:

```text
kodekloud_db5
```

### Step 5

Create the MySQL Deployment.

The Deployment is named

```text
mysql-deployment
```

It uses:

```text
mysql:8.0
```

The MySQL container exposes

```text
3306
```

The PersistentVolumeClaim is mounted at

```text
/var/lib/mysql
```

### Step 6

Configure the MySQL environment variables.

Root password:

```yaml
- name: MYSQL_ROOT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-root-pass
      key: password
```

Database:

```yaml
- name: MYSQL_DATABASE
  valueFrom:
    secretKeyRef:
      name: mysql-db-url
      key: database
```

Username:

```yaml
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
      name: mysql-user-pass
      key: username
```

Password:

```yaml
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-user-pass
      key: password
```

### Step 7

Create the MySQL Service.

The Service is named:

```text
mysql
```

It uses

```text
NodePort
```

The Service forwards

```text
30007 -> 3306
```

### Step 8

Apply the configuration

```bash
kubectl apply -f mysql.yaml
```

# 4. Verify the Deployment

Check the PersistentVolume

```bash
kubectl get pv mysql-pv
```

Check the PersistentVolumeClaim:

```bash
kubectl get pvc mysql-pv-claim
```

Check the Deployment

```bash
kubectl get deployment mysql-deployment
```

Check the MySQL Pod

```bash
kubectl get pods
```

Check the Service

```bash
kubectl get svc mysql
```

# 5. Verify the Secrets

List the Secrets

```bash
kubectl get secrets
```

The following Secrets should exist

```text
mysql-root-pass
mysql-user-pass
mysql-db-url
```

You can inspect the Secret configuration with

```bash
kubectl describe secret mysql-root-pass
kubectl describe secret mysql-user-pass
kubectl describe secret mysql-db-url
```

# 6. Verify MySQL Storage

Check the Pod

```bash
kubectl describe pod -l app=mysql
```

# 7. Main Takeaways

- PersistentVolumes provide storage for Kubernetes workloads
- PersistentVolumeClaims request storage from available PersistentVolumes
- Kubernetes Secrets can store database credentials and configuration values
- Environment variables can consume values directly from Secrets
- MySQL data is mounted at `/var/lib/mysql`
- A NodePort Service can expose MySQL outside the cluster
- The required NodePort is `30007`

# 8. Conclusion

The MySQL database was deployed on Kubernetes with the required persistent storage, Secrets, Deployment, and NodePort Service.

The PersistentVolume and PersistentVolumeClaim provide storage for MySQL data, while Kubernetes Secrets provide the required database credentials and configuration.

The MySQL Deployment should be running with the Service available through NodePort `30007`.
