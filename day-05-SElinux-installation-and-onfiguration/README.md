# Install and Permanently Disable SELinux

## 1. What is the Challenge?

As part of a security initiative, the xFusionCorp Industries security team wants to begin testing Security-Enhanced Linux (SELinux) on App Server 3.

The requirements are:

- Install the necessary SELinux packages
- Permanently disable SELinux for now
- Do not reboot the server manually
- Ignore the current SELinux status shown by command-line tools
- After the scheduled reboot, SELinux must be in the **disabled** state

## 2. Required Technology to Solve It

### Linux Operating System

Basic Linux administration knowledge is required.

### SELinux

SELinux (Security-Enhanced Linux) is a Linux security module that provides mandatory access control (MAC) policies to enhance system security.

### Linux Commands

#### yum / dnf

Used to install required packages.

```bash
yum install -y selinux-policy selinux-policy-targeted policycoreutils
```

#### grep

Used to verify configuration settings.

```bash
grep ^SELINUX= /etc/selinux/config
```

#### sed

Used to modify configuration files from the command line.

```bash
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
```

## 3. How to Solve It

### Step 1: Connect to App Server 3

```bash
ssh user@stapp03
```

### Step 2: Install SELinux Packages

```bash
sudo yum install -y selinux-policy selinux-policy-targeted policycoreutils
```

> On newer systems, `dnf` can be used instead of `yum`

### Step 3: Update SELinux Configuration

Open the SELinux configuration file:

```bash
sudo vi /etc/selinux/config
```

Find:

```ini
SELINUX=enforcing
```

or

```ini
SELINUX=permissive
```

Replace it with:

```ini
SELINUX=disabled
```

Final configuration:

```ini
SELINUX=disabled
SELINUXTYPE=targeted
```

### Step 4: Verify the Configuration

```bash
grep ^SELINUX= /etc/selinux/config
```

Expected output:

```bash
SELINUX=disabled
```

## 4. Main Takeaways

### SELinux Modes

SELinux supports three operating modes:

| Mode       | Description                            |
| ---------- | -------------------------------------- |
| Enforcing  | SELinux policies are actively enforced |
| Permissive | Violations are logged but not blocked  |
| Disabled   | SELinux is completely turned off       |

### Permanent Configuration

The file:

```bash
/etc/selinux/config
```

controls the SELinux mode after a reboot.

## 5. Conclusion

This task demonstrates how to install SELinux-related packages and configure SELinux to be permanently disabled after the next system reboot.

Although SELinux is a powerful security feature, it is sometimes temporarily disabled during testing, migration, or application compatibility assessments. By updating the SELinux configuration file, we ensure that the system will boot with SELinux disabled during the scheduled maintenance reboot.
