# Configure Password-less SSH Access

## 1. What is the Challenge?

The xFusionCorp Industries automation scripts run from the Jump Host and need to connect to all application servers without requiring passwords.

The goal is to configure SSH key-based authentication so that the user `thor` can connect to each application server using its designated sudo user.

### Server information

| Server  | User   |
| ------- | ------ |
| stapp01 | tony   |
| stapp02 | steve  |
| stapp03 | banner |

## 2. Required Technology to Solve It

### SSH (Secure Shell)

SSH provides secure remote access between Linux systems.

### SSH Key Authentication

Instead of passwords, SSH uses a public/private key pair to authenticate users.

## 3. How to Solve It

### Generate SSH Key

```bash
ssh-keygen
```

### Copy Key to App Server 1

```bash
ssh-copy-id tony@stapp01
```

### Copy Key to App Server 2

```bash
ssh-copy-id steve@stapp02
```

### Copy Key to App Server 3

```bash
ssh-copy-id banner@stapp03
```

### Verify Password-less Access

```bash
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```

## 4. Main Takeaways

### Public Key Authentication

SSH key authentication is more secure and convenient than password-based login.

### Public and Private Keys

- Private Key → Stays on the Jump Host.
- Public Key → Copied to remote servers.

### authorized_keys

Remote servers store trusted public keys in:

```bash
~/.ssh/authorized_keys
```

### Automation Benefits

Password less SSH is essential for:

- Automation scripts
- Ansible
- Cron jobs
- CI/CD pipelines

## 5. Conclusion

This task demonstrates how to configure password less SSH access using public key authentication. Once configured, the user `thor` can securely connect to all application servers without entering passwords, enabling seamless automation across the infrastructure.
