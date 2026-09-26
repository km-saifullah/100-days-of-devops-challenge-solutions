# Create a Temporary User with an Expiry Date

## What is the Challenge

The Nautilus project requires temporary access for a developer named `rose`.

The user account must be created on **App Server 2** in the Stratos Datacenter and must have a specific expiry date so that the account is limited to the required period.

The required user is

```text
rose
```

The required expiry date is

```text
2024-02-17
```

The username must be created in lowercase.

The solution is implemented using a Bash script.

## Required Technology to Solve It

The following Linux tools and concepts are used

- Linux
- Bash
- `useradd`
- `chage`
- `id`
- Account expiration
- SSH

### Target Configuration

| Item            | Value        |
| --------------- | ------------ |
| Server          | App Server 2 |
| Hostname        | `stapp02`    |
| User            | `rose`       |
| Username Format | Lowercase    |
| Expiry Date     | `2024-02-17` |
| Solution        | Bash script  |

# How to Solve It

## Step 1: Connect to App Server 2

From the jump host, connect to App Server 2

```bash
ssh steve@stapp02
```

Verify the server

```bash
hostname
```

Expected Output

```text
stapp02
```

## Step 2: Create the Bash Solution

Create the solution file:

```bash
vi solution.sh
```

Add the following

```bash
#!/bin/bash

useradd -e 2024-02-17 rose

if id rose >/dev/null 2>&1; then
    echo "User rose created successfully."
    echo "Expiry date: $(chage -l rose | grep "Account expires" | cut -d: -f2 | xargs)"
else
    echo "Failed to create user rose."
    exit 1
fi
```

## Step 3: Make the Script Executable

Run:

```bash
chmod +x solution.sh
```

Verify:

```bash
ls -l solution.sh
```

## Step 4: Execute the Solution

Run the script with root privileges

```bash
sudo ./solution.sh
```

The script creates the user with

```text
rose
```

and assigns the required account expiry date

```text
2024-02-17
```

# Understanding the Command

The main command used by the script is

```bash
useradd -e 2024-02-17 rose
```

The options work as follows

| Option       | Purpose                               |
| ------------ | ------------------------------------- |
| `useradd`    | Creates a Linux user                  |
| `-e`         | Specifies the account expiration date |
| `2024-02-17` | Required expiration date              |
| `rose`       | Username                              |

The username is explicitly lowercase as required by the task.

# Step 5: Verify the User

Check that the user exists

```bash
id rose
```

The command should return the UID and group information for `rose`.

# Step 6: Verify the Expiry Date

Use `chage` to inspect the account settings

```bash
sudo chage -l rose
```

The output should contain

```text
Account expires : Feb 17, 2024
```

This confirms that the account has the required expiry date.

# Complete Solution

The solution consists of

```text
solution.sh
```

Complete contents

```bash
#!/bin/bash

useradd -e 2024-02-17 rose

if id rose >/dev/null 2>&1; then
    echo "User rose created successfully."
    echo "Expiry date: $(chage -l rose | grep "Account expires" | cut -d: -f2 | xargs)"
else
    echo "Failed to create user rose."
    exit 1
fi
```

# Main Takeaways

### 1. `useradd` Creates Linux Users

The `useradd` command is used to create a new Linux user account.

### 2. `-e` Sets an Account Expiration Date

The `-e` option allows an account expiration date to be specified when creating the user

```bash
useradd -e 2024-02-17 rose
```

### 3. `chage` Verifies Account Expiration

The account expiration configuration can be checked with

```bash
chage -l rose
```

### 4. Usernames Should Follow the Required Format

The task specifically requires the username to be lowercase

```text
rose
```

# Conclusion

The Bash solution creates the `rose` user on App Server 2 with the required account expiry date and verifies the user configuration successfully.
