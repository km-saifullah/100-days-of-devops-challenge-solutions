# Create a User with a Non-Interactive Shell

## What is the Challenge

The xFusionCorp Industries system administration team requires a user account for a backup agent tool.

The backup agent requires a user with a **non-interactive shell**.

The task is to create a user named:

```text
mariyam
```

on:

```text
App Server 2
```

The user must be configured with a non-interactive shell.

The solution is implemented as a Bash script.

## Required Technology to Solve It

The following Linux technologies and commands are used

- Linux
- Bash
- `useradd`
- `/sbin/nologin`
- `getent`
- `id`
- SSH

### Target

| Item     | Value           |
| -------- | --------------- |
| Server   | App Server 2    |
| Hostname | `stapp02`       |
| User     | `mariyam`       |
| Shell    | `/sbin/nologin` |
| Solution | Bash script     |

# How to Solve It

## Step 1: Connect to App Server 2

From the jump host, connect to App Server 2

```bash
ssh steve@stapp02
```

Verify the hostname

```bash
hostname
```

Expected

```text
stapp02
```

## Step 2: Create the Bash Solution File

Create the solution file

```bash
vi solution.sh
```

Use the following complete script

```bash
#!/bin/bash

useradd -s /sbin/nologin mariyam

if id mariyam >/dev/null 2>&1; then
    echo "User mariyam created successfully."
    echo "Shell: $(getent passwd mariyam | cut -d: -f7)"
else
    echo "Failed to create user mariyam."
    exit 1
fi
```

## Step 3: Make the Script Executable

Run

```bash
chmod +x solution.sh
```

Verify

```bash
ls -l solution.sh
```

The script should have executable permissions.

## Step 4: Execute the Solution

Run the Bash script

```bash
sudo ./solution.sh
```

Expected output

```text
User mariyam created successfully.
Shell: /sbin/nologin
```

The script creates the user with

```text
/sbin/nologin
```

as the login shell.

# How the Script Works

The main user-creation command is

```bash
useradd -s /sbin/nologin mariyam
```

The `-s` option specifies the user's login shell.

The username is

```text
mariyam
```

The configured shell is

```text
/sbin/nologin
```

The script then verifies that the user exists

```bash
id mariyam
```

Finally, it retrieves and displays the configured shell

```bash
getent passwd mariyam | cut -d: -f7
```

# Verification

After running the script, verify the user directly

```bash
getent passwd mariyam
```

The output should contain

```text
mariyam:x:UID:GID::/home/mariyam:/sbin/nologin
```

You can also check only the shell

```bash
getent passwd mariyam | cut -d: -f7
```

Expected output

```text
/sbin/nologin
```

Verify that the user exists

```bash
id mariyam
```
