# Install and Configure Apache Inside a Docker Container

## 1. What is the Challenge?

The objective is to configure the **kkloud** Docker container running on **Application Server 2**.

The required tasks are:

- Install **apache2** inside the **kkloud** container using **apt**
- Configure Apache to listen on **port 6100** instead of the default port **80**
- Ensure Apache listens on **all interfaces** (not a specific IP address)
- Start the Apache service inside the container
- Keep the **kkloud** container in the running state

# 2. Required Technology to Solve It

- Linux
- Docker
- Ubuntu
- Apache2
- APT

# 3. How to Solve It

### Step 1

SSH into **Application Server 2**.

```bash
ssh steve@stapp02
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Verify that the **kkloud** container is running.

```bash
docker ps
```

### Step 3

Access the running container.

```bash
docker exec -it kkloud bash
```

### Step 4

Update the package index.

```bash
apt update
```

### Step 5

Install Apache.

```bash
apt install -y apache2
```

> **Note:** During installation, you may see:

```text
invoke-rc.d: policy-rc.d denied execution of start.
```

This is **normal** inside Docker containers. Apache must be started manually.

### Step 6

Configure Apache to listen on **port 6100**.

Update **ports.conf**:

```bash
sed -i 's/Listen 80/Listen 6100/' /etc/apache2/ports.conf
```

Update the default virtual host:

```bash
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:6100>/' /etc/apache2/sites-available/000-default.conf
```

> Keep the VirtualHost as `*:6100`. Do **not** replace `*` with `127.0.0.1` or any specific IP address.

### Step 7

Restart Apache.

```bash
service apache2 restart
```

### Step 8

Verify that Apache is running.

```bash
service apache2 status
```

### Step 9

Verify Apache is listening on port **6100**.

```bash
netstat -tlnp | grep 6100
```

Expected output:

```text
tcp        0      0 0.0.0.0:6100      0.0.0.0:*      LISTEN
```

### Step 10

Exit the container.

```bash
exit
```

Verify that the container is still running.

```bash
docker ps
```

# 4. Main Takeaways

- Learned how to install software inside a running Docker container
- Configured Apache to use a custom port
- Used `sed` to modify configuration files quickly
- Restarted Apache manually because services do not automatically start inside most Docker containers
- Verified both the Apache service and the Docker container

# 5. Conclusion

This task demonstrates how to configure services inside a running Docker container. After installing Apache, changing the listening port to **6100**, and manually starting the service, the **kkloud** container is ready for application testing while remaining in the running state.
