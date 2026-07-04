# MariaDB Database Server Configuration

## 1. What is the Challenge?

The objective is to prepare the Nautilus Database Server for application deployment by installing and configuring a MariaDB database server. After installation, a new database and a dedicated database user must be created, and the required permissions must be assigned.

Requirements:

- Install and configure MariaDB Server
- Create a database named **kodekloud_db2**
- Create a user named **kodekloud_cap**
- Set the password to **TmPcZjtRQx**
- Grant the user full privileges on **kodekloud_db2**

# 2. Required Technology to Solve It

## Linux

Provides the operating system environment for managing services and packages.

## MariaDB

An open-source relational database server compatible with MySQL.

## MySQL Client

Used to connect to MariaDB and execute SQL statements.

# 3. How to Solve It

### Step 1

Connect to the database server.

```bash
ssh peter@stdb01
```

### Step 2

Install MariaDB.

```bash
yum install -y mariadb-server
```

### Step 3

Start and enable the MariaDB service.

```bash
systemctl enable mariadb
systemctl start mariadb
```

### Step 4

Create the required database.

```sql
CREATE DATABASE kodekloud_db2;
```

### Step 5

Create the database user.

```sql
CREATE USER 'kodekloud_cap'@'localhost' IDENTIFIED BY 'TmPcZjtRQx';
```

### Step 6

Grant full privileges.

```sql
GRANT ALL PRIVILEGES ON kodekloud_db2.* TO 'kodekloud_cap'@'localhost';
FLUSH PRIVILEGES;
```

### Step 7

Verify the configuration.

```sql
SHOW DATABASES;
SHOW GRANTS FOR 'kodekloud_cap'@'localhost';
```

# 4. Main Takeaways

- MariaDB is a drop-in replacement for MySQL
- Databases should have dedicated users rather than using the root account
- `GRANT ALL PRIVILEGES` assigns full access to a specific database
- `FLUSH PRIVILEGES` reloads the privilege tables immediately after permission changes

# 5. Conclusion

This task demonstrates the basic administration of a MariaDB server by installing the database service, creating a database, creating a dedicated database user, and assigning the necessary permissions. These are common tasks performed before deploying applications that rely on a relational database backend.
