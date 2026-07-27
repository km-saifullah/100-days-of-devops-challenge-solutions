# Create a Custom Docker Image with Apache on Ubuntu 24.04

## 1. What is the Challenge?

The objective is to create a **Dockerfile** on **Application Server 3** that can build a custom Docker image.

The Docker image must:

- Use **ubuntu:24.04** as the base image
- Install **apache2**
- Configure Apache to listen on **port 6000**
- Do **not** modify any other Apache configuration (such as the document root)

The Dockerfile must be created at:

```text
/opt/docker/Dockerfile
```

# 2. Required Technology to Solve It

- Linux
- Docker
- Dockerfile
- Ubuntu 24.04
- Apache2
- APT

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

Create the Docker build directory.

```bash
mkdir -p /opt/docker
```

### Step 3

Create the Dockerfile.

```bash
vi /opt/docker/Dockerfile
```

Add the following content:

```dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 && \
    sed -i 's/Listen 80/Listen 6000/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:6000>/' /etc/apache2/sites-available/000-default.conf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6000

CMD ["apachectl", "-D", "FOREGROUND"]
```

### Step 4

Save the file.

Verify it:

```bash
cat /opt/docker/Dockerfile
```

### Step 5 (Optional)

Build the Docker image to verify the Dockerfile.

```bash
docker build -t custom-apache /opt/docker
```

### Step 6 (Optional)

Run a container from the image.

```bash
docker run -d --name apache-test -p 6000:6000 custom-apache
```

# 4. Main Takeaways

- Learned how to create a Dockerfile
- Used **Ubuntu 24.04** as the base image
- Installed Apache automatically during the image build
- Configured Apache to listen on a custom port
- Started Apache in the foreground so the container remains running

# 5. Conclusion

This task demonstrates how to build a custom Docker image using a Dockerfile. By installing Apache during the build process and updating only the listening port to **6000**, the image meets the project requirements while leaving all other Apache settings unchanged.
