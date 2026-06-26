# Archive Website Content Using a Bash Script

## 1. What is the Challenge?

The production support team needs to automate the backup of a static website hosted on App Server 1.

The task is to create a Bash script named `ecommerce_archive.sh` that:

- Creates a ZIP archive of the website content
- Stores the archive in a local temporary archive directory
- Copies the archive to the Nautilus Storage Server for long-term storage
- Uses password-less SSH for file transfer

## 2. Required Technology to Solve It

### Linux Operating System

Basic Linux command-line and file management skills.

### Bash Scripting

Used to automate the backup process.

### zip

Creates compressed ZIP archives.

Example:

```bash
zip -r archive.zip directory
```

### SCP (Secure Copy)

Transfers files securely between Linux servers over SSH.

Example:

```bash
scp file user@server:/destination
```

### SSH Key Authentication

Allows secure, password-less communication between servers.

## 3. How to Solve It

### Step 1: Install the zip Package

```bash
sudo yum install -y zip
```

### Step 2: Configure Password-less SSH

Generate an SSH key:

```bash
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
```

Copy the public key to the storage server:

```bash
ssh-copy-id user@ststor01
```

### Step 3: Create the Bash Script

The script should:

- Compress `/var/www/html/ecommerce`
- Save the archive as:

```text
xfusioncorp_ecommerce.zip
```

inside:

```text
/archives
```

- Copy the archive to:

```text
ststor01:/archives
```

### Step 4: Make the Script Executable

```bash
chmod +x /scripts/ecommerce_archive.sh
```

### Step 5: Execute the Script

```bash
/scripts/ecommerce_archive.sh
```

## 4. Main Takeaways

### Bash Automation

Bash scripts simplify repetitive administrative tasks such as backups.

### ZIP Compression

The `zip` command creates compressed archives suitable for storage and transfer.

### Secure File Transfer

`scp` uses SSH to securely copy files between systems.

### Password-less SSH

SSH key-based authentication enables automated scripts to connect to remote systems without user interaction.

### Script Permissions

A script must have execute permission before it can be run:

```bash
chmod +x script.sh
```

## 5. Conclusion

This task demonstrates how to automate website backups using Bash scripting. The script creates a compressed archive, stores it locally, and transfers it to a remote storage server using secure, password-less SSH authentication.
