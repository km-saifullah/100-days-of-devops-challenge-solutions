# Install Docker CE and Docker Compose

## 1. What is the Challenge?

The objective is to prepare **App Server 1** for containerized applications by installing **Docker CE** and **Docker Compose**, and ensuring that the Docker service is running.

The required tasks are:

- Install **docker-ce**
- Install **docker compose**
- Start and enable the Docker service

# 2. Required Technology to Solve It

- Linux
- Docker CE
- Docker Compose
- Systemd
- DNF / YUM

# 3. How to Solve It

### Step 1

SSH into **App Server 1**.

```bash
ssh tony@stapp01
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Install the Docker repository.

```bash
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

### Step 3

Install Docker CE and Docker Compose.

```bash
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### Step 4

Enable and start the Docker service.

```bash
systemctl enable docker
systemctl start docker
```

### Step 5

Verify the installation.

Check Docker version:

```bash
docker --version
```

Check Docker Compose version:

```bash
docker compose version
```

Verify the Docker service:

```bash
systemctl status docker
```

Expected status:

```text
Active: active (running)
```

# 4. Main Takeaways

- Learned how to install Docker CE
- Installed Docker Compose using the Docker Compose plugin
- Enabled Docker to start automatically on boot
- Verified that the Docker service is running successfully

# 5. Conclusion

This task demonstrates the basic setup required before deploying containerized applications. After installing Docker CE and Docker Compose and starting the Docker service, the server is ready to build and run Docker containers.
