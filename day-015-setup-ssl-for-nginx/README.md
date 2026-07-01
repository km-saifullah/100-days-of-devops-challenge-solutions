# Configure Nginx with SSL on App Server 2

## 1. What is the Challenge?

The application team needs **App Server 2** prepared for a new deployment. The server must have **Nginx** installed and configured to serve HTTPS using a provided self-signed SSL certificate. Additionally, a simple web page displaying **"Welcome!"** must be deployed and verified from the Jump Host.

# 2. Required Technology to Solve It

## Linux

Provides the operating system and administration tools.

## Nginx

A high-performance web server and reverse proxy.

## SSL/TLS

Encrypts communication between the client and the web server.

## Systemd

Manages the Nginx service.

## Useful Commands

Install Nginx:

```bash
yum install -y nginx
```

Test Nginx configuration:

```bash
nginx -t
```

Manage the service:

```bash
systemctl restart nginx
systemctl status nginx
```

Verify HTTPS:

```bash
curl -Ik https://stapp02/
```

# 3. How to Solve It

### Step 1

Install Nginx.

```bash
yum install -y nginx
```

### Step 2

Create an SSL directory and move the provided certificate and key.

```bash
mkdir -p /etc/nginx/ssl

mv /tmp/nautilus.crt /etc/nginx/ssl/
mv /tmp/nautilus.key /etc/nginx/ssl/
```

### Step 3

Configure Nginx to use HTTPS.

```nginx
listen 443 ssl;

ssl_certificate /etc/nginx/ssl/nautilus.crt;
ssl_certificate_key /etc/nginx/ssl/nautilus.key;
```

### Step 4

Create the website.

```bash
echo "Welcome!" > /usr/share/nginx/html/index.html
```

### Step 5

Validate the configuration.

```bash
nginx -t
```

### Step 6

Start and enable Nginx.

```bash
systemctl enable nginx
systemctl restart nginx
```

### Step 7

Verify the deployment from the Jump Host.

```bash
curl -Ik https://stapp02/
```

Expected response:

```text
HTTP/1.1 200 OK
```

# 4. Main Takeaways

- Always validate the Nginx configuration before restarting the service.
- Store SSL certificates in a dedicated directory such as `/etc/nginx/ssl`.
- Apply secure file permissions to private keys.
- Test HTTPS locally before verifying from a remote host.
- Self-signed certificates require the `-k` option with `curl` because they are not signed by a trusted Certificate Authority.

# 5. Conclusion

This task demonstrates how to prepare a Linux server for secure web hosting using **Nginx** and **SSL/TLS**. By installing Nginx, deploying the provided certificate and key, creating a simple web page, and validating HTTPS connectivity, the server is ready for application deployment.
