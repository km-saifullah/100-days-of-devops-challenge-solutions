# Deploy an Nginx Alpine Docker Container

## 1. What is the Challenge?

The objective is to deploy an **Nginx** container on **Application Server 1** using the **nginx:alpine** image.

The required tasks are:

- Create a Docker container named **nginx_1**
- Use the **nginx:alpine** image
- Ensure the container is in the **running** state

# 2. Required Technology to Solve It

- Linux
- Docker CE
- Docker Hub
- Nginx (Alpine Image)

# 3. How to Solve It

### Step 1

SSH into **Application Server 1**.

```bash
ssh tony@stapp01
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Verify that Docker is installed and running.

```bash
systemctl status docker
```

If Docker is not running, start it.

```bash
systemctl enable docker
systemctl start docker
```

### Step 3

Pull the **nginx:alpine** image.

```bash
docker pull nginx:alpine
```

### Step 4

Create and start the container.

```bash
docker run -d --name nginx_1 nginx:alpine
```

### Step 5

Verify that the container is running.

```bash
docker ps
```

Expected output should include:

```text
CONTAINER ID   IMAGE           COMMAND                  STATUS
xxxxxxx        nginx:alpine    "/docker-entrypoint.…"  Up ...
```

### Step 6

View the container logs.

```bash
docker logs nginx_1
```

# 4. Main Takeaways

- Learned how to pull an image from Docker Hub
- Created a Docker container using the **nginx:alpine** image
- Assigned a custom container name
- Verified that the container is running successfully
- Used Docker commands to inspect and monitor the container

# 5. Conclusion

This task demonstrates the basic workflow of deploying a Docker container. By using the lightweight **nginx:alpine** image and assigning the container the required name (**nginx_1**), the application server becomes ready for further container-based deployment and testing.
