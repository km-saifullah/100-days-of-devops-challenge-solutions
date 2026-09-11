# Ansible Samba Package Installation

## Overview

The Nautilus DevOps team required Samba to be installed on all application servers in the Stratos Datacenter using Ansible.

The Jump Host acts as the Ansible controller, and the `thor` user is used to execute the Ansible commands and playbook.

The task includes configuring passwordless SSH access from the Jump Host to all application servers, creating an Ansible inventory, and creating a playbook that installs the `samba` package using the Ansible `yum` module.

## Infrastructure

| Server               | Hostname    | SSH User |
| -------------------- | ----------- | -------- |
| Application Server 1 | `stapp01`   | `tony`   |
| Application Server 2 | `stapp02`   | `steve`  |
| Application Server 3 | `stapp03`   | `banner` |
| Jump Host            | `jump-host` | `thor`   |

The Ansible controller is

```text
Jump Host
```

The Ansible playbook is executed using

```text
thor
```

## Prerequisites

Ansible should be installed on the Jump Host.

Verify

```bash
ansible --version
```

The `thor` user must also have an SSH key available.

Check

```bash
ls -la /home/thor/.ssh/
```

If an SSH key does not exist, create one

```bash
ssh-keygen -t ed25519
```

Press Enter for the default location and leave the passphrase empty.

## Configure Passwordless SSH

All of the following commands are executed on the Jump Host as the `thor` user.

### Application Server 1

Copy the SSH public key to App Server 1

```bash
ssh-copy-id tony@stapp01
```

Test the connection

```bash
ssh -o BatchMode=yes tony@stapp01 'hostname'
```

### Application Server 2

Copy the SSH public key

```bash
ssh-copy-id steve@stapp02
```

```bash
ssh -o BatchMode=yes steve@stapp02 'hostname'
```

E

### Application Server 3

Copy the SSH public key

```bash
ssh-copy-id banner@stapp03
```

```bash
ssh -o BatchMode=yes banner@stapp03 'hostname'
```

## Verify SSH Authentication

All three connections should work without requesting a password.

```bash
ssh -o BatchMode=yes tony@stapp01 'hostname'
ssh -o BatchMode=yes steve@stapp02 'hostname'
ssh -o BatchMode=yes banner@stapp03 'hostname'
```

## Create the Ansible Inventory

Go to the directory

```bash
cd /home/thor/playbook
```

Create the inventory

```bash
vi inventory
```

Use the following complete inventory:

```ini
[appservers]
stapp01 ansible_host=stapp01 ansible_user=tony
stapp02 ansible_host=stapp02 ansible_user=steve
stapp03 ansible_host=stapp03 ansible_user=banner
```

The inventory contains all three application servers.

## Test Ansible Connectivity

Before running the playbook, test connectivity to all managed nodes

```bash
cd /home/thor/playbook
ansible -i inventory all -m ping
```

The important response from each server is

```text
"ping": "pong"
```

## Create the Ansible Playbook

```bash
cd /home/thor/playbook
vi playbook.yml
```

Use the following complete playbook

```yaml
---
- name: Install Samba on all application servers
  hosts: appservers
  become: true

  tasks:
    - name: Install samba package
      ansible.builtin.yum:
        name: samba
        state: present
```

## Run the Playbook

From the Jump Host as `thor`

```bash
cd /home/thor/playbook
```

Run

```bash
ansible-playbook -i inventory playbook.yml
```

This is also the exact command expected by the validation system.

## Verify Samba Installation

After the playbook completes successfully, verify Samba on all application servers

```bash
ansible -i inventory all -m shell -a 'rpm -q samba'
```

You can also check whether the Samba executable is available

```bash
ansible -i inventory all -m command -a 'which smbd'
```

## SSH Troubleshooting

### Permission Denied

If Ansible reports

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)
```

test SSH manually

```bash
ssh tony@stapp01
```

If passwordless authentication does not work, run

```bash
ssh-copy-id tony@stapp01
```

Repeat the same process for

```bash
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
```

### Test the SSH Key Directly

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o BatchMode=yes tony@stapp01 'hostname'
```

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o BatchMode=yes steve@stapp02 'hostname'
```

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o BatchMode=yes banner@stapp03 'hostname'
```

Each command should return the corresponding hostname without asking for a password.

## Final Validation

Run the exact validation command

```bash
cd /home/thor/playbook
ansible-playbook -i inventory playbook.yml
```

Then verify connectivity

```bash
ansible -i inventory all -m ping
```

Finally verify Samba

```bash
ansible -i inventory all -m shell -a 'rpm -q samba'
```

The inventory and playbook are configured so the task can be executed without any additional command-line arguments.

## Conclusion

The Ansible inventory and playbook were created successfully, passwordless SSH access was configured between the Jump Host and application servers, and the Samba package installation was automated and verified across all application servers.
