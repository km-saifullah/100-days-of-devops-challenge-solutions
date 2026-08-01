# Deploy a PHP and MariaDB Stack Using Docker Compose

## 1. What is the Challenge?

The objective is to deploy a **PHP web application** and a **MariaDB database** using **Docker Compose** on **Application Server 2**.

The Docker Compose file must be created at:

```text
/opt/devops/docker-compose.yml
```

The stack should include:

### Web Service

- Container name: **php_web**
- Image: **php** with any Apache tag
- Host port **8084** → Container port **80**
- Mount host directory:

```text
/var/www/html
```

to

```text
/var/www/html
```

inside the container.

### Database Service

- Container name: **mysql_web**
- Image: **mariadb**
- Host port **3306** → Container port **3306**
- Mount host directory:

```text
/var/lib/mysql
```

to

```text
/var/lib/mysql
```

inside the container.

Database configuration:

- Database name:

```text
database_web
```

- Create a custom user (not root)
- Use a strong password

# 2. Required Technology to Solve It

- Linux
- Docker
- Docker Compose
- PHP Apache
- MariaDB

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
mkdir -p /opt/devops
```

### Step 3

Create the Docker Compose file.

```bash
vi /opt/devops/docker-compose.yml
```

Paste the following configuration:

```yaml
version: "3.8"

services:
  web:
    image: php:apache
    container_name: php_web
    ports:
      - "8084:80"
    volumes:
      - /var/www/html:/var/www/html
    restart: unless-stopped

  db:
    image: mariadb:latest
    container_name: mysql_web
    ports:
      - "3306:3306"
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    environment:
      MYSQL_DATABASE: database_web
      MYSQL_USER: appuser
      MYSQL_PASSWORD: Str@tos123!
      MYSQL_ROOT_PASSWORD: Root@12345!
    restart: unless-stopped
```

### Step 4

Navigate to the project directory.

```bash
cd /opt/devops
```

### Step 5

Deploy the stack.

```bash
docker compose up -d
```

Docker Compose will automatically:

- Pull the PHP Apache image
- Pull the MariaDB image
- Create both containers
- Configure port mappings
- Mount the required host directories

### Step 6

Verify the deployment.

```bash
docker compose ps
```

or

```bash
docker ps
```

Expected output:

```text
php_web
mysql_web
```

Both containers should be in the **Up** state.

### Step 7

Test the web application.

```bash
curl http://localhost:8084
```

If everything is configured correctly, the PHP Apache web server will respond successfully.

# 4. Main Takeaways

- Learned how to deploy multiple containers using Docker Compose
- Configured persistent storage using Docker volumes
- Mapped host ports to container ports
- Configured a MariaDB database using environment variables
- Verified the deployment using Docker Compose and cURL

# 5. Conclusion

This task demonstrates how Docker Compose can simplify the deployment of a multi-container application. By defining both the PHP web server and the MariaDB database in a single configuration file, the complete application stack can be deployed and managed using one command.
