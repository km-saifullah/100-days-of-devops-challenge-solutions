# Deploy an Apache (httpd) Container Using Docker Compose

## 1. What is the Challenge?

The objective is to deploy an **Apache (httpd)** container on **Application Server 2** using **Docker Compose**.

The requirements are:

- Create a Docker Compose file at **/opt/docker/docker-compose.yml**
- Use the **httpd:latest** image
- Name the container **httpd**
- Map **host port 6000** to **container port 80**
- Mount the host directory **/opt/dba** to the container directory **/usr/local/apache2/htdocs**
- Do **not** modify any existing data in the mounted directory

# 2. Required Technology to Solve It

- Linux
- Docker
- Docker Compose
- Apache HTTP Server (httpd)

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

Create the Docker Compose directory.

```bash
mkdir -p /opt/docker
```

### Step 3

Create the Docker Compose file.

```bash
vi /opt/docker/docker-compose.yml
```

Add the following configuration:

```yaml
version: "3.8"

services:
  web:
    image: httpd:latest
    container_name: httpd
    ports:
      - "6000:80"
    volumes:
      - /opt/dba:/usr/local/apache2/htdocs
    restart: unless-stopped
```

### Step 4

Navigate to the Docker Compose directory.

```bash
cd /opt/docker
```

### Step 5

Start the container.

```bash
docker compose up -d
```

Docker Compose will automatically:

- Pull the latest **httpd** image (if it is not already available)
- Create a container named **httpd**
- Map port **6000** on the host to port **80** inside the container
- Mount the host directory `/opt/dba` as the Apache document root

### Step 6

Verify the container is running.

```bash
docker ps
```

or

```bash
docker compose ps
```

Expected output:

```text
NAME    IMAGE          STATUS
httpd   httpd:latest   Up
```

### Step 7

Test the web server.

```bash
curl http://localhost:6000
```

If the mounted directory contains an `index.html` file, its contents should be displayed.

# 4. Main Takeaways

- Learned how to deploy containers using Docker Compose
- Used the latest Apache (`httpd`) image
- Mapped a host port to the container's web server port
- Mounted a host directory into the container as a persistent volume
- Verified the deployment using Docker Compose and `curl`

# 5. Conclusion

This task demonstrates how to deploy an Apache web server using Docker Compose. By defining the service, port mapping, container name, and volume mount in a Compose file, the application can be started consistently with a single command while serving content directly from the host directory.
