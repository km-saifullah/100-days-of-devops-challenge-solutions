# Fix Nginx and PHP-FPM Volume Mount Issue

## 1. What is the Challenge?

The objective is to fix an existing Nginx and PHP-FPM application running inside the Kubernetes Pod:

```text
nginx-phpfpm
```

The ConfigMap is:

```text
nginx-config
```

The application is not working because the shared volume paths and the Nginx document root are inconsistent.

The required document root is:

```text
/usr/share/nginx/html
```

The Nginx container is:

```text
nginx-container
```

The PHP-FPM container is:

```text
php-fpm-container
```

After fixing the configuration, `/home/thor/index.php` must be copied into the Nginx document root.

# 2. Required Technology to Solve It

- Linux
- Kubernetes
- kubectl
- Nginx
- PHP-FPM
- ConfigMap
- emptyDir Volume

# 3. How to Solve It

### Step 1

Inspect the existing Pod.

```bash
kubectl describe pod nginx-phpfpm
```

The Pod contains:

```text
nginx-container
php-fpm-container
```

Both containers use a shared `emptyDir` volume.

### Step 2

Fix the Nginx ConfigMap.

```bash
kubectl edit configmap nginx-config
```

Find:

```nginx
root /var/www/html;
```

Change it to:

```nginx
root /usr/share/nginx/html;
```

Save and exit.

The Nginx document root and the shared volume mount must use the same path.

### Step 3

Export the existing Pod configuration.

```bash
kubectl get pod nginx-phpfpm -o yaml > pod.yaml
```

Open the file:

```bash
vi pod.yaml
```

Find the `nginx-container` volume mount.

Change:

```yaml
- mountPath: /var/www/html
  name: shared-files
```

to:

```yaml
- mountPath: /usr/share/nginx/html
  name: shared-files
```

The container name must remain:

```text
nginx-container
```

### Step 4

Recreate the Pod.

Pod volume mount configuration is not changed using a normal Pod edit, so recreate the Pod using:

```bash
kubectl replace --force -f pod.yaml
```

### Step 5

Check the Pod status.

```bash
kubectl get pod nginx-phpfpm
```

The expected state is:

```text
READY   STATUS
2/2     Running
```

### Step 6

Copy `index.php` into the Nginx document root.

```bash
kubectl cp /home/thor/index.php \
  nginx-phpfpm:/usr/share/nginx/html/index.php \
  -c nginx-container
```

### Step 7

Verify the file.

```bash
kubectl exec nginx-phpfpm -c nginx-container \
  -- ls -l /usr/share/nginx/html/
```

The output should contain:

```text
index.php
```

### Step 8

Verify both containers.

```bash
kubectl get pod nginx-phpfpm
```

Make sure the Pod is:

```text
Running
```

and both containers are ready:

```text
2/2
```

### Step 9

Open the **Website** button from the KodeKloud lab.

The PHP application should now be accessible.

# 4. Main Takeaways

- The shared volume must use the same mount path in both containers
- Nginx uses `/usr/share/nginx/html` as its standard document root
- The Nginx ConfigMap must point to the same directory used by the shared volume
- Pod volume mounts are immutable, so the Pod must be recreated when changing them
- `kubectl cp -c nginx-container` can be used to copy files into a specific container

# 5. Conclusion

The issue was caused by an inconsistent document-root and shared-volume configuration.

The incorrect path:

```text
/var/www/html
```

was changed to:

```text
/usr/share/nginx/html
```

in both the Nginx configuration and the Nginx container's shared volume mount.

The `index.php` file was then copied into:

```text
/usr/share/nginx/html/index.php
```

The final configuration is:

```text
Pod:
nginx-phpfpm

Nginx container:
nginx-container

PHP-FPM container:
php-fpm-container

Nginx document root:
 /usr/share/nginx/html

PHP file:
 /usr/share/nginx/html/index.php
```
