# Fix Apache Service Not Reachable on Port 8082

## 1. What is the Challenge?

The monitoring system reported that the Apache web server on **App Server 1** was not reachable on **port 8082**.

Investigation showed that Apache could not start because another service (**Sendmail**) was already using the same port. The objective was to identify the conflict, resolve it, restore the Apache service, and verify that the website could be accessed from the Jump Host.

# 2. Required Technology to Solve It

## Linux

Basic Linux administration and troubleshooting.

## Apache HTTP Server

Hosts the web application.

## Systemd

Used to manage Linux services.

## Sendmail

A mail transfer agent that was occupying Apache's required port.

## iptables

Controls network access to the server.

## Common Commands

Check Apache:

```bash
systemctl status httpd
```

Check listening ports:

```bash
ss -tlnp
```

Identify the process using a port:

```bash
lsof -i :8082
```

Test connectivity:

```bash
curl http://localhost:8082
```

# 3. How to Solve It

### Step 1

Check Apache status.

```bash
systemctl status httpd
```

Apache reported:

```
Address already in use
```

### Step 2

Identify which process owns port **8082**.

```bash
ss -tlnp
```

or

```bash
lsof -i :8082
```

The output showed that **Sendmail** was already listening on the port.

### Step 3

Modify the Sendmail configuration so it no longer uses port **8082**.

Regenerate the configuration:

```bash
make
```

Restart Sendmail:

```bash
systemctl restart sendmail
```

### Step 4

Start Apache.

```bash
systemctl restart httpd
```

Enable it to start automatically.

```bash
systemctl enable httpd
```

### Step 5

Allow port **8082** through the firewall if required.

```bash
iptables -I INPUT -p tcp --dport 8082 -j ACCEPT
```

### Step 6

Verify the service.

```bash
curl http://localhost:8082
```

From the Jump Host:

```bash
curl http://stapp01:8082
```

# 4. Main Takeaways

- Always inspect the service status before making changes
- "Address already in use" usually indicates a port conflict
- Use `ss` or `lsof` to identify which process owns a port
- Apache cannot bind to a port that is already occupied
- Keep troubleshooting scripts idempotent so they can be executed multiple times safely
- Verify the solution both locally and remotely

# 5. Conclusion

This task demonstrates a common Linux troubleshooting scenario where Apache failed to start because another service was already listening on the required port. By identifying the conflicting service, correcting its configuration, ensuring firewall access, and restarting Apache, the web server became reachable again from the Jump Host.
