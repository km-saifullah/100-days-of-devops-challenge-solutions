# Create a Docker Image from an Existing Container

## 1. What is the Challenge?

The objective is to create a new Docker image from an existing running container on **Application Server 1**.

The required tasks are:

- Use the running container **ubuntu_latest**
- Create a new image named **games** with the tag **nautilus**
- Preserve the current state of the container in the new image

# 2. Required Technology to Solve It

- Linux
- Docker CE
- Docker Images
- Docker Containers

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

Verify that the container **ubuntu_latest** is running.

```bash
docker ps
```

Expected output should include:

```text
ubuntu_latest
```

### Step 3

Create a new image from the running container.

```bash
docker commit ubuntu_latest games:nautilus
```

Docker will return the newly created image ID.

### Step 4

Verify that the image has been created.

```bash
docker images
```

Expected output:

```text
REPOSITORY   TAG         IMAGE ID
games        nautilus    xxxxxxxxxxxx
```

# 4. Main Takeaways

- Learned how to create a Docker image from a running container
- Used the `docker commit` command
- Preserved the container's current state as a reusable image
- Verified the image using Docker commands

# 5. Conclusion

This task demonstrates how to create a reusable Docker image from an existing container. The `docker commit` command captures the current filesystem and configuration of the container, making it easy to preserve work and deploy identical containers in the future.
