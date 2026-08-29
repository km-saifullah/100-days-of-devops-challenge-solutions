# Jenkins Database Backup Job

## Objective

Create a Jenkins job named `database-backup` to automatically take a backup of the `kodekloud_db01` MySQL database running on App Server 1 and copy the generated backup to the Storage Server.

The job is also scheduled to run automatically every 10 minutes.

### Database Details

- Database: `kodekloud_db01`
- Database User: `kodekloud_roy`
- Database Password: `asdfgdsd`

### Backup Location

```text
/home/natasha/db_backups
```

### Backup Filename

```text
db_$(date +%F).sql
```

# Configure SSH Access

The Jenkins job runs as the Linux `jenkins` user.

Root access is not required. Generate an SSH key on the Jenkins server as the `jenkins` user

```bash
su - jenkins
```

Generate the key

```bash
ssh-keygen -t ed25519
```

Press `Enter` to accept the default location and leave the passphrase empty.

Display the public key

```bash
cat ~/.ssh/id_ed25519.pub
```

# Configure SSH Access to App Server 1

Connect to App Server 1

```bash
ssh tony@stapp01
```

Create the SSH directory

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Add the Jenkins public key

```bash
vi ~/.ssh/authorized_keys
```

Paste the Jenkins public key and save the file.

Set the correct permissions

```bash
chmod 600 ~/.ssh/authorized_keys
```

Test the connection

```bash
ssh -o StrictHostKeyChecking=no tony@stapp01 hostname
```

# Configure SSH Access to Storage Server

Connect to the Storage Server

```bash
ssh natasha@ststor01
```

Create the SSH directory

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Add the same Jenkins public key

```bash
vi ~/.ssh/authorized_keys
```

Save the public key and set permissions

```bash
chmod 600 ~/.ssh/authorized_keys
```

Test the connection

```bash
ssh -o StrictHostKeyChecking=no natasha@ststor01 hostname
```

# Test Database Access

Connect to App Server 1

```bash
ssh tony@stapp01
```

Test the database credentials

```bash
mysql -u kodekloud_roy -p
```

Enter

```text
asdfgdsd
```

Verify the database

```sql
SHOW DATABASES;
```

Confirm that `kodekloud_db01` exists.

Exit MySQL

```sql
exit
```

Then exit the server

```bash
exit
```

# Test Database Dump

From the Jenkins server as the `jenkins` user

```bash
ssh tony@stapp01 \
'MYSQL_PWD="asdfgdsd" mysqldump -u kodekloud_roy kodekloud_db01 > /tmp/db_$(date +%F).sql'
```

Verify the generated dump

```bash
ssh tony@stapp01 \
'ls -lh /tmp/db_$(date +%F).sql'
```

# Test Copying the Backup

Copy the backup from App Server 1 to the Jenkins server

```bash
scp tony@stapp01:/tmp/db_$(date +%F).sql /tmp/
```

Create the destination directory on the Storage Server

```bash
ssh natasha@ststor01 \
'mkdir -p /home/natasha/db_backups'
```

Copy the backup to the Storage Server

```bash
scp /tmp/db_$(date +%F).sql \
natasha@ststor01:/home/natasha/db_backups/
```

Verify

```bash
ssh natasha@ststor01 \
'ls -lh /home/natasha/db_backups/'
```

# Create Jenkins Job

Open the Jenkins UI and log in using

```text
Username: admin
Password: Adm!n321
```

Create a new job

```text
database-backup
```

Select

```text
Freestyle project
```

# 8. Configure Build Step

Go to

```text
Build
→ Add build step
→ Execute shell
```

Use the following script

```bash
#!/bin/bash

DATE=$(date +%F)
FILE="db_${DATE}.sql"

echo "Creating database dump on stapp01..."

ssh -o StrictHostKeyChecking=no tony@stapp01 \
  "MYSQL_PWD='asdfgdsd' mysqldump -u kodekloud_roy kodekloud_db01 > /tmp/${FILE}"

if [ $? -ne 0 ]; then
    echo "Database dump failed"
    exit 1
fi

echo "Copying dump from stapp01 to Jenkins..."

scp -o StrictHostKeyChecking=no \
  tony@stapp01:/tmp/${FILE} \
  /tmp/${FILE}

if [ $? -ne 0 ]; then
    echo "Failed to copy dump from stapp01"
    exit 1
fi

echo "Copying dump to storage server..."

ssh -o StrictHostKeyChecking=no natasha@ststor01 \
  "mkdir -p /home/natasha/db_backups"

scp -o StrictHostKeyChecking=no \
  /tmp/${FILE} \
  natasha@ststor01:/home/natasha/db_backups/

if [ $? -ne 0 ]; then
    echo "Failed to copy dump to storage server"
    exit 1
fi

echo "Database backup completed successfully: ${FILE}"
```

Save the job configuration.

# Configure Periodic Build

Under **Build Triggers**, select

```text
Build periodically
```

Use the exact cron expression

```text
*/10 * * * *
```

This schedules the job to run every 10 minutes.

# Run the Job

Click

```text
Build Now
```

Open

```text
Console Output
```

The build should complete with

```text
Finished: SUCCESS
```

# Verify the Backup

Connect to the Storage Server

```bash
ssh natasha@ststor01
```

Check the backup directory

```bash
ls -lh /home/natasha/db_backups/
```

The backup should be present in the following format

```text
db_YYYY-MM-DD.sql
```

# Conclusion

The Jenkins database backup job was successfully configured and verified. The required database backup is generated in the specified format, transferred to the Storage Server, and scheduled to run periodically every 10 minutes.
