# Pull and Re-Tag a Docker Image

## 1. What is the Challenge?

The objective is to prepare a Docker image for application testing on **App Server 1**.

The required tasks are:

- Pull the **busybox:musl** image from Docker Hub
- Create a new tag named **busybox:media** for the same image

# 2. Required Technology to Solve It

- Linux
- Docker CE
- Docker Hub

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

Verify that the Docker service is running.

```bash
systemctl status docker
```

If Docker is not running, start it.

```bash
systemctl start docker
```

### Step 3

Pull the required Docker image.

```bash
docker pull busybox:musl
```

### Step 4

Create a new tag for the image.

```bash
docker tag busybox:musl busybox:media
```

### Step 5

Verify that both image tags are available.

```bash
docker images
```

Expected output:

```text
REPOSITORY   TAG      IMAGE ID
busybox      musl     xxxxxxxxxxxx
busybox      media    xxxxxxxxxxxx
```

Both tags should have the **same IMAGE ID**, confirming they reference the same image.

# 4. Main Takeaways

- Learned how to download Docker images from Docker Hub
- Created a custom tag for an existing image
- Verified that multiple tags can point to the same Docker image
- Used Docker CLI commands to inspect local images

# 5. Conclusion

This task demonstrates how to manage Docker images by creating additional tags. Re-tagging allows the same image to be referenced using different names or versions without duplicating the image, making it useful for testing, deployment, and version management.
