# Fix Dockerfile Build Errors

## 1. What is the Challenge?

The objective is to fix an existing **Dockerfile** located at:

```text
/opt/docker/Dockerfile
```

The Docker image should build successfully without changing:

- Base image
- Existing application data
- HTML files
- Other valid Dockerfile configurations

# 2. Required Technology to Solve It

- Linux
- Docker
- Dockerfile
- Apache HTTP Server

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

Open the Dockerfile.

```bash
vi /opt/docker/Dockerfile
```

### Step 3

Replace the incorrect `cp` commands with `COPY`.

Incorrect:

```dockerfile
RUN cp certs/server.crt /usr/local/apache2/conf/server.crt

RUN cp certs/server.key /usr/local/apache2/conf/server.key

RUN cp html/index.html /usr/local/apache2/htdocs/
```

Correct:

```dockerfile
COPY certs/server.crt /usr/local/apache2/conf/server.crt

COPY certs/server.key /usr/local/apache2/conf/server.key

COPY html/index.html /usr/local/apache2/htdocs/index.html
```

### Step 4

Save the Dockerfile.

### Step 5

Build the image.

```bash
cd /opt/docker

docker build -t httpd-custom .
```

If the build completes successfully, the task is complete.

# 4. Main Takeaways

- Learned the difference between `RUN cp` and `COPY`
- `COPY` copies files from the Docker build context into the image
- `RUN cp` only copies files that already exist inside the image
- Always build the Docker image to verify the Dockerfile before submitting

# 5. Conclusion

This task demonstrates how to troubleshoot Dockerfile build failures. The issue was caused by using shell `cp` commands to copy files that only exist in the Docker build context. Replacing them with Docker's `COPY` instruction allows the image to build successfully without changing the base image or application data.
