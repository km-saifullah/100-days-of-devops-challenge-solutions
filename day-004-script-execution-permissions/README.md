# Grant Executable Permission to a Script

## 1. What is the Challenge?

The xFusionCorp Industries sysadmin team created a backup automation script named `xfusioncorp.sh` and distributed it across multiple servers.

However, on **App Server 3**, the script located at:

```bash
/tmp/xfusioncorp.sh
```

does not have executable permissions.

### Objective

- Grant executable permission to the script
- Ensure that **all users** can execute the script
- Verify that the permissions have been applied successfully

## 2. Required Technology to Solve It

The following technologies and concepts are required:

### Linux Operating System

Basic understanding of Linux file permissions and CLI operations.

### Bash Shell

Knowledge of executing commands in a Linux terminal.

### Linux Commands

#### chmod

Used to modify file permissions.

Example:

```bash
chmod a+x /tmp/xfusioncorp.sh
```

#### ls

Used to verify file permissions.

Example:

```bash
ls -l /tmp/xfusioncorp.sh
```

## 3. How to Solve It

### Step 1: Connect to App Server 3

```bash
ssh user@stapp03
```

### Step 2: Check Current Permissions

```bash
ls -l /tmp/xfusioncorp.sh
```

Example output:

```bash
-rw-r--r-- 1 root root 120 Jun 20 10:00 /tmp/xfusioncorp.sh
```

Notice that the execute (`x`) permission is missing.

### Step 3: Grant Execute Permission to All Users

```bash
chmod a+x /tmp/xfusioncorp.sh
```

Alternatively:

```bash
chmod 755 /tmp/xfusioncorp.sh
```

### Step 4: Verify the Result

```bash
ls -l /tmp/xfusioncorp.sh
```

Expected output:

```bash
-rwxr-xr-x 1 root root 120 Jun 20 10:00 /tmp/xfusioncorp.sh
```

The output indicates that:

- Owner can read, write, and execute
- Group can read and execute
- Others can read and execute

## 4. Main Takeaways

### Linux Permissions

Linux permissions consist of:

```text
Owner | Group | Others
```

### chmod a+x

The command:

```bash
chmod a+x filename
```

adds execute permission for:

- Owner
- Group
- Others

### Permission Verification

Always verify changes using:

```bash
ls -l filename
```

### Security Awareness

Grant only the permissions required for a task. In this scenario, execute permission for all users is explicitly required.

## 5. Conclusion

This task demonstrates a fundamental Linux administration skill: managing file permissions.

By using the `chmod` command, we successfully enabled execution of the backup script for all users on App Server 3. Understanding Linux permissions is essential for system administration, automation, DevOps, and security-related tasks.
