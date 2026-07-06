# PostgreSQL Database Configuration

## 1. What is the Challenge?

The application development team requires a PostgreSQL database before deploying their application. The database server is already installed, but a new database user and database need to be created with the appropriate permissions.

Requirements:

- Create a PostgreSQL user named **kodekloud_roy**
- Set the password to **8FmzjvFU6S**
- Create a database named **kodekloud_db3**
- Grant the user full privileges on the database
- Do **not** restart the PostgreSQL service

# 2. Required Technology to Solve It

### PostgreSQL

Used to manage relational databases.

### Linux

Provides the operating system environment.

### psql

The PostgreSQL command-line client used for database administration.

Useful commands:

Switch to the PostgreSQL user:

```bash
su - postgres
```

Open PostgreSQL:

```bash
psql
```

Exit PostgreSQL:

```sql
\q
```

# 3. How to Solve It

### Step 1

Connect to the database server.

```bash
ssh peter@stdb01
```

### Step 2

Switch to the PostgreSQL system user.

```bash
su - postgres
```

### Step 3

Open the PostgreSQL shell.

```bash
psql
```

### Step 4

Create the database user.

```sql
CREATE USER kodekloud_roy WITH PASSWORD '8FmzjvFU6S';
```

### Step 5

Create the database.

```sql
CREATE DATABASE kodekloud_db3;
```

### Step 6

Grant all privileges.

```sql
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db3 TO kodekloud_roy;
```

### Step 7

Verify the configuration.

List users:

```sql
\du
```

List databases:

```sql
\l
```

# 4. Main Takeaways

- PostgreSQL separates users (roles) and databases
- A database user must have permissions before accessing a database
- `GRANT ALL PRIVILEGES` provides complete access to the specified database
- The PostgreSQL service does not need to be restarted after creating users or databases

# 5. Conclusion

This task demonstrates basic PostgreSQL administration by creating a database user, creating a new database, and granting the necessary privileges. These are common preparatory steps before deploying applications that require a PostgreSQL backend.
