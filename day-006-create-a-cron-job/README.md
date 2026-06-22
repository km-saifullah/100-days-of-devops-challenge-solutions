# Install Cronie and Configure a Cron Job

## 1. What is the Challenge?

The Nautilus system administrators want to test automated task scheduling before deploying production automation scripts.

The requirements are:

- Install the `cronie` package on all application servers
- Start and enable the `crond` service
- Create a cron job for the root user
- The cron job should run every 5 minutes and write `hello` to `/tmp/cron_text`

## 2. Required Technology to Solve It

### Linux Operating System

Basic Linux administration skills.

### Cronie

Cronie provides the cron daemon (`crond`) used to schedule recurring tasks.

### Systemd

Used to manage Linux services.

### Commands Used

#### Install Package

```bash
yum install -y cronie
```

#### Start Service

```bash
systemctl start crond
```

#### Enable Service

```bash
systemctl enable crond
```

#### Edit Root Crontab

```bash
crontab -e
```

## 3. How to Solve It

### Install Cronie

```bash
yum install -y cronie
```

### Start and Enable Cron Service

```bash
systemctl enable crond
systemctl start crond
```

### Create Cron Job

```bash
crontab -e
```

Add:

```cron
*/5 * * * * echo hello > /tmp/cron_text
```

### Verify

```bash
crontab -l
```

## 4. Main Takeaways

### Cron Syntax

```cron
*/5 * * * *
```

Means:

- Every 5 minutes
- Every hour
- Every day

## 5. Conclusion

This task demonstrates how to install and configure the cron scheduling system on Linux servers. By installing the `cronie` package, starting the `crond` service, and creating a root cron job, automated tasks can be executed at regular intervals.
