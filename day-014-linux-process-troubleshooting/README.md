# Linuc Process Troubleshooting

## 1. What is the Challenge?

The monitoring system reported that the Apache service was unavailable on one of the application servers in the Stratos Datacenter.

The objectives were:

- Identify the faulty application server
- Restore the Apache service
- Configure Apache to listen on **port 3003**
- Ensure Apache is running successfully on all application servers

During troubleshooting, the root cause was found to be a **port conflict**. The **Sendmail** service was configured to listen on port **3003**, preventing Apache from starting.

# 2. Required Technology to Solve It

## Linux

Provides the operating system and administration tools.

## Apache HTTP Server

Hosts web applications and listens for incoming HTTP requests.

## Systemd

Used to manage Linux services.

## Sendmail

Mail Transfer Agent (MTA). In this case, it was incorrectly configured to use Apache's port.

## SELinux

May require custom HTTP ports to be registered before Apache can bind to them.

# 3. How to Solve It

### Step 1

Identify the faulty application server.

```bash
systemctl status httpd
```

Apache reported an error similar to:

```
Address already in use
```

### Step 2

Determine which process owns port **3003**.

```bash
ss -tlnp | grep 3003
```

Output:

```
sendmail
```

This confirmed that **Sendmail** was occupying the required Apache port.

### Step 3

Update the Sendmail configuration.

Edit:

```bash
/etc/mail/sendmail.mc
```

Replace:

```
Port=3003
```

with:

```
Port=smtp
```

Regenerate the configuration:

```bash
cd /etc/mail
make
```

Restart Sendmail:

```bash
systemctl restart sendmail
```

### Step 4

Configure Apache to listen on port **3003**.

```bash
grep "^Listen" /etc/httpd/conf/httpd.conf
```

Expected:

```
Listen 3003
```

### Step 5

If SELinux is enforcing, register port **3003**.

```bash
semanage port -a -t http_port_t -p tcp 3003
```

### Step 6

Restart Apache.

```bash
systemctl enable httpd
systemctl restart httpd
```

### Step 7

Verify the service.

```bash
systemctl status httpd
```

Verify the listening port.

```bash
ss -tlnp | grep 3003
```

Expected output:

```
httpd listening on port 3003
```

# 4. Main Takeaways

- Always inspect the service status before changing configurations
- The error **"Address already in use"** almost always indicates a port conflict
- Use **ss** or **lsof** to identify the process occupying the required port
- A TCP port can only be used by one service at a time
- Keep configuration backups before making changes
- Validate the service after every modification

# 5. Conclusion

This task demonstrates a common Linux system administration scenario involving service troubleshooting. Apache failed to start because **Sendmail** was incorrectly configured to use port **3003**. By restoring Sendmail to its default SMTP port, configuring Apache correctly, and restarting the service, the application server was restored successfully. The same verification process should be performed on all application servers to ensure Apache is active and listening on port **3003**.
