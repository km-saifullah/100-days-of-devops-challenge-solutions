# Configure Nginx Load Balancer on the LBR Server

## 1. What is the Challenge?

The production website has experienced increased traffic, causing performance degradation. To improve availability and distribute incoming requests, the LBR server must be configured as a load balancer using **Nginx**.

Requirements:

- Install Nginx on the LBR server
- Configure load balancing using all three application servers
- Do not modify the existing Apache port on any application server
- Ensure Apache is running on every application server
- Verify access through `http://stlb01`

# 2. Required Technology to Solve It

## Linux

Provides the operating system and administration tools.

## Nginx

Acts as a reverse proxy and load balancer.

## Apache HTTP Server

Hosts the web application on each application server.

## Systemd

Manages Linux services.

# 3. How to Solve It

### Step 1

Install Nginx on the LBR server.

```bash
yum install -y nginx
```

### Step 2

Verify Apache is active on all application servers.

```bash
systemctl status httpd
```

### Step 3

Identify the Apache listening port.

```bash
grep "^Listen" /etc/httpd/conf/httpd.conf
```

Use this existing port in the upstream configuration.

### Step 4

Edit `/etc/nginx/nginx.conf` and define an upstream group containing:

- stapp01
- stapp02
- stapp03

Configure a server block listening on port **80** and forward requests using:

```nginx
proxy_pass http://app_servers;
```

### Step 5

Validate the configuration.

```bash
nginx -t
```

### Step 6

Enable and restart Nginx.

```bash
systemctl enable nginx
systemctl restart nginx
```

### Step 7

Verify the deployment.

```bash
curl http://stlb01
```

The response should display the webpage served by one of the backend application servers.

# 4. Main Takeaways

- Nginx can distribute traffic across multiple backend servers
- The `upstream` block defines the backend server pool
- `proxy_pass` forwards incoming requests to the upstream group
- Always validate Nginx configuration before restarting the service
- Preserve the existing Apache configuration on backend servers

# 5. Conclusion

This task demonstrates how to configure **Nginx** as a reverse proxy and load balancer. By creating an upstream group with all application servers and forwarding incoming requests through the LBR server, traffic is distributed efficiently without changing the Apache configuration on the backend systems. This improves scalability and availability while keeping the deployment simple.
