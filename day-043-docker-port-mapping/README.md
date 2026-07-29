# Deploy an Nginx Container Using Docker

## 1. What is the Challenge?

The objective is to deploy an **Nginx** container on **Application Server 3**.

The requirements are:

- Pull the **nginx:stable** Docker image
- Create a container named **beta**
- Map **host port 3001** to **container port 80**
- Keep the container in the **running** state

# 2. Required Technology to Solve It

- Linux
- Docker
- Docker Hub
- Nginx

# 3. How to Solve It

### Step 1

SSH into **Application Server 3**.

```bash
ssh banner@stapp03
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Pull the required Docker image.

```bash
docker pull nginx:stable
```

### Step 3

Create and start the container.

```bash
docker run -d \
  --name beta \
  -p 3001:80 \
  nginx:stable
```

Where:

- `-d` runs the container in detached mode
- `--name beta` assigns the container name
- `-p 3001:80` maps host port **3001** to container port **80**

### Step 4

Verify the container is running.

```bash
docker ps
```

Expected output:

```text
CONTAINER ID   IMAGE          PORTS
xxxxxxxxxxxx   nginx:stable   0.0.0.0:3001->80/tcp
```

### Step 5

Verify the Docker image.

```bash
docker images
```

### Step 6

Test the Nginx container.

```bash
curl http://localhost:3001
```

You should receive the default **Welcome to nginx!** page.

# 4. Main Takeaways

- Learned how to pull an image from Docker Hub
- Created a container from the **nginx:stable** image
- Mapped a host port to a container port
- Verified that the container is running
- Tested the application using `curl`

# 5. Conclusion

This task demonstrates how to deploy an Nginx container using Docker. By pulling the required image, creating a container with a custom name, and mapping the host port to the container port, the application becomes accessible while the container continues running in the background.
