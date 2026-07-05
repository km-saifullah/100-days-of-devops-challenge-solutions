# Deploy Two Static Websites on Apache

## 1. What is the Challenge?

The objective is to prepare **App Server 1** to host two static websites using the Apache HTTP Server. The website backups are available on the Jump Host and must be deployed so they are accessible through separate URL paths.

Requirements:

- Install Apache HTTP Server
- Configure Apache to listen on **port 5004**
- Deploy the **official** website under `/official/`
- Deploy the **cluster** website under `/cluster/`
- Verify both websites using `curl`

# 2. Required Technology to Solve It

## Linux

Provides the operating system and server management tools.

## Apache HTTP Server (httpd)

Hosts and serves the static websites.

## SCP

Transfers the website backups from the Jump Host to the application server.

## cURL

Used to verify that the deployed websites are accessible.

# 3. How to Solve It

### Step 1

Copy the website backups from the Jump Host.

```bash
scp -r /home/thor/official tony@stapp01:/tmp/
scp -r /home/thor/cluster tony@stapp01:/tmp/
```

### Step 2

Install Apache.

```bash
yum install -y httpd
```

### Step 3

Configure Apache to listen on **port 5004** by editing:

```text
/etc/httpd/conf/httpd.conf
```

Update:

```apache
Listen 80
```

to:

```apache
Listen 5004
```

### Step 4

Create the website directories.

```bash
mkdir -p /var/www/html/official
mkdir -p /var/www/html/cluster
```

### Step 5

Copy the website files.

```bash
cp -r /tmp/official/* /var/www/html/official/
cp -r /tmp/cluster/* /var/www/html/cluster/
```

### Step 6

Assign the correct ownership and permissions.

```bash
chown -R apache:apache /var/www/html/official
chown -R apache:apache /var/www/html/cluster

chmod -R 755 /var/www/html/official
chmod -R 755 /var/www/html/cluster
```

### Step 7

Enable and restart Apache.

```bash
systemctl enable httpd
systemctl restart httpd
```

### Step 8

Verify the deployment.

```bash
curl http://localhost:5004/official/
curl http://localhost:5004/cluster/
```

Both commands should return the respective website content.

# 4. Main Takeaways

- Apache can host multiple websites under different URL paths
- Static websites can be deployed by copying files into the web document root
- Configuring Apache to use a custom port requires updating the `Listen` directive
- Proper file ownership and permissions are essential for Apache to serve content correctly

# 5. Conclusion

This task demonstrates how to prepare an Apache web server for hosting multiple static websites. By configuring Apache to listen on a custom port, deploying website files into separate directories, and verifying access with `curl`, the server is ready to host multiple applications under different URL paths.
