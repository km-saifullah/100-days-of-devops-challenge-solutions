# Install Ansible 4.9.0 on Jump Host

## 1. What is the Challenge?

The Nautilus DevOps team has chosen Ansible as their configuration management and automation tool.

The task is to:

- Install Ansible version **4.9.0** on the Jump Host
- Use **pip3** as the installation method
- Ensure the Ansible command is available globally for all users

## 2. Required Technology to Solve It

### Ansible

Ansible is an open-source automation tool used for:

- Configuration management
- Application deployment
- Infrastructure automation

### Python

Ansible is written in Python and can be installed using `pip3`.

### pip3

Python package manager used to install Ansible.

## 3. How to Solve It

### Verify pip3

```bash
pip3 --version
```

### Install Ansible 4.9.0

```bash
pip3 install ansible==4.9.0
```

### Check Installation Path

```bash
which ansible
```

### Make Ansible Globally Available

```bash
ln -s /usr/local/bin/ansible /usr/bin/ansible
```

### Verify Installation

```bash
ansible --version
```

## 4. Main Takeaways

### Why Ansible?

- Agentless architecture
- Easy setup
- Uses SSH for communication
- Simple YAML-based playbooks

### pip3 Installation

Using pip allows installation of specific Ansible versions.

### Global Accessibility

Making the binary available in `/usr/bin` ensures all users can execute Ansible commands without modifying their PATH.

### Verification

Always confirm installation using:

```bash
ansible --version
```

## 5. Conclusion

This task demonstrates how to install a specific version of Ansible using Python's package manager and make it available system-wide. Once installed, the Jump Host can act as an Ansible Controller and manage remote servers through SSH.
