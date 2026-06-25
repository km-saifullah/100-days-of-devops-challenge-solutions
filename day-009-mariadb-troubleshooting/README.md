# Fix MariaDB Service on Database Server

## 1. What is the Challenge?

The production support team reported that the Nautilus application could not connect to the database.

Investigation revealed that the MariaDB service on the database server was down. Further inspection showed that MariaDB could not start because its data directory was not properly initialized and contained unexpected files.

### Objective

- Investigate why the MariaDB service failed
- Fix the underlying issue
- Start the MariaDB service successfully
- Restore database connectivity for the application

## 2. Required Technology to Solve It

### Linux Operating System

Basic Linux administration and troubleshooting skills.

### MariaDB

MariaDB is an open-source relational database management system used by the Nautilus application.

### Systemd

Used to manage Linux services.

### Commands Used

#### Check Service Status

```bash
systemctl status mariadb
```

#### View Service Logs

```bash
journalctl -xeu mariadb
```

#### Initialize Database

```bash
mariadb-install-db --user=mysql --datadir=/var/lib/mysql
```

#### Set Ownership

```bash
chown -R mysql:mysql /var/lib/mysql
```

#### Start Service

```bash
systemctl start mariadb
```

## 3. How to Solve It

### Step 1: Check MariaDB Status

```bash
systemctl status mariadb -l
```

The output showed:

```text
Database MariaDB is not initialized, but the directory /var/lib/mysql is not empty
```

### Step 2: Inspect the Data Directory

```bash
ls -la /var/lib/mysql
```

Identify unexpected or leftover files preventing initialization.

### Step 3: Remove or Move Problematic Files

Example:

```bash
rm -rf /var/lib/mysql/<unwanted-file>
```

or

```bash
mv /var/lib/mysql/<unwanted-file> /tmp/
```

### Step 4: Initialize MariaDB

```bash
mariadb-install-db --user=mysql --datadir=/var/lib/mysql
```

### Step 5: Fix Permissions

```bash
chown -R mysql:mysql /var/lib/mysql
```

### Step 6: Start MariaDB

```bash
systemctl start mariadb
```

### Step 7: Verify

```bash
systemctl status mariadb
```

Expected output:

```text
Active: active (running)
```

## 4. Main Takeaways

### Service Troubleshooting

Always begin with:

```bash
systemctl status <service>
```

and

```bash
journalctl -xeu <service>
```

to identify the root cause.

### MariaDB Data Directory

The default MariaDB data directory is:

```bash
/var/lib/mysql
```

If the directory contains unexpected files, initialization may fail.

### Database Initialization

MariaDB system tables can be recreated using:

```bash
mariadb-install-db
```

### File Ownership

Database files must be owned by the MySQL user:

```bash
mysql:mysql
```

Incorrect ownership often prevents database startup.

## 5. Conclusion

This task demonstrates a common database troubleshooting scenario. By examining the MariaDB service logs, identifying an improperly initialized data directory, reinitializing the database, correcting file ownership, and restarting the service, the database server was successfully restored.
