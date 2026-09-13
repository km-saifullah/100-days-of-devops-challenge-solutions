# Ansible vsftpd Package Installation and Service Management

## Overview

The Nautilus DevOps team required `vsftpd` to be installed, started, and enabled on all application servers in the Stratos Datacenter using Ansible.

The Jump Host acts as the Ansible controller, and the `thor` user is used to execute the Ansible commands and playbook.

The task includes verifying SSH access from the Jump Host to all application servers using password-based authentication, using the existing Ansible inventory, and creating a playbook that installs the `vsftpd` package and ensures the `vsftpd` service is started and enabled on boot.

## Infrastructure

| Server               | Hostname    | SSH User | SSH Auth |
| -------------------- | ----------- | -------- | -------- |
| Application Server 1 | `stapp01`   | `tony`   | Password |
| Application Server 2 | `stapp02`   | `steve`  | Password |
| Application Server 3 | `stapp03`   | `banner` | Password |
| Jump Host            | `jump-host` | `thor`   | -        |

The Ansible controller is

```text
Jump Host
```

The Ansible playbook is executed using

```text
thor
```

## Existing Ansible Inventory

The inventory file already exists on the Jump Host at

```text
/home/thor/ansible/inventory
```

Unlike a key-based setup, this inventory uses password authentication via `ansible_ssh_pass`, and it is a flat list with **no `[appservers]` group header**:

```bash
cat inventory
```

```ini
stapp01 ansible_host=stapp01 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=stapp02 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=stapp03 ansible_ssh_pass=BigGr33n ansible_user=banner
```

No changes to the inventory are required — the playbook is written to target `all` hosts instead of a named group (see below).

## Prerequisites

Ansible should be installed on the Jump Host.

Verify

```bash
ansible --version
```

Since the inventory uses `ansible_ssh_pass`, `sshpass` must also be installed on the Jump Host for Ansible to authenticate with a password

```bash
sudo yum install -y sshpass
```

(use `sudo apt install -y sshpass` on a Debian/Ubuntu-based Jump Host)

## SSH Troubleshooting

### Host Key Verification Failed

Testing SSH directly at first failed with

```text
Host key verification failed.
```

for all three application servers

```bash
ssh -o BatchMode=yes tony@stapp01 'hostname'
ssh -o BatchMode=yes steve@stapp02 'hostname'
ssh -o BatchMode=yes banner@stapp03 'hostname'
```

This happens because the Jump Host had never connected to these hosts before, so their host keys were not yet trusted — this is unrelated to password vs key authentication.

### ssh-copy-id Not Applicable

Since this setup uses password authentication (not SSH keys), `ssh-copy-id` is not needed and fails anyway since `thor` has no local keypair

```bash
ssh-copy-id tony@stapp01
```

```text
ERROR: No identities found
```

This error can be ignored — no keypair is required for this task.

### Fix: Trust the Host Keys

Add the application servers' host keys to `known_hosts` non-interactively

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keyscan -H stapp01 stapp02 stapp03 >> ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
```

### Verify SSH with Password Authentication

```bash
sshpass -p 'Ir0nM@n' ssh tony@stapp01 'hostname'
sshpass -p 'Am3ric@' ssh steve@stapp02 'hostname'
sshpass -p 'BigGr33n' ssh banner@stapp03 'hostname'
```

Each command should now return the corresponding hostname without any host key prompt.

## Test Ansible Connectivity

Before creating or running the playbook, confirm connectivity to all managed nodes

```bash
cd /home/thor/ansible
ansible -i inventory all -m ping
```

The important response from each server is

```text
"ping": "pong"
```

All three servers (`stapp01`, `stapp02`, `stapp03`) returned success.

## Create the Ansible Playbook

```bash
cd /home/thor/ansible
vi playbook.yml
```

### Initial Attempt (Failed)

The first version of the playbook targeted a named group

```yaml
hosts: appservers
```

Running it produced

```text
[WARNING]: Could not match supplied host pattern, ignoring: appservers

PLAY [Install and enable vsftpd on all application servers] **************
skipping: no hosts matched

PLAY RECAP *****************************************************************
```

This happened because the inventory has **no `[appservers]` group** — it is a flat list of hosts with no group header, so the `appservers` pattern matched nothing.

### Fix: Target `all` Instead of a Named Group

Since the inventory should not be modified, the playbook was updated to use `hosts: all`, which matches every host in the inventory regardless of grouping.

Use the following complete, working playbook

```yaml
---
- name: Install and enable vsftpd on all application servers
  hosts: all
  become: true

  tasks:
    - name: Install vsftpd package
      ansible.builtin.yum:
        name: vsftpd
        state: present

    - name: Start and enable vsftpd service
      ansible.builtin.service:
        name: vsftpd
        state: started
        enabled: true
```

This playbook does two things on every host in the inventory:

1. Installs the `vsftpd` package using the `ansible.builtin.yum` module.
2. Starts the `vsftpd` service immediately and enables it so it starts automatically on future reboots, using the `ansible.builtin.service` module.

## Run the Playbook

From the Jump Host as `thor`

```bash
cd /home/thor/ansible
```

Run

```bash
ansible-playbook -i inventory playbook.yml
```

This is also the exact command expected by the validation system, so no extra arguments are required. `become: true` handles privilege escalation on each application server for the install and service tasks.

## Verify vsftpd Installation and Service Status

After the playbook completes successfully, verify vsftpd on all application servers

```bash
ansible -i inventory all -m shell -a 'rpm -q vsftpd'
```

Check that the service is running

```bash
ansible -i inventory all -m shell -a 'systemctl is-active vsftpd'
```

Check that the service is enabled on boot

```bash
ansible -i inventory all -m shell -a 'systemctl is-enabled vsftpd'
```

Both commands should return `active` and `enabled` respectively for all three application servers.

## Final Validation

Run the exact validation command

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

Then verify connectivity

```bash
ansible -i inventory all -m ping
```

Finally verify vsftpd installation and service state

```bash
ansible -i inventory all -m shell -a 'rpm -q vsftpd'
ansible -i inventory all -m shell -a 'systemctl is-active vsftpd'
ansible -i inventory all -m shell -a 'systemctl is-enabled vsftpd'
```

The inventory and playbook are configured so the task can be executed without any additional command-line arguments.

## Conclusion

The Ansible playbook was created at `/home/thor/ansible/playbook.yml`, using the existing password-authenticated inventory at `/home/thor/ansible/inventory` without modification. Two issues were resolved along the way: an untrusted host key (fixed with `ssh-keyscan`) and a playbook targeting a non-existent `appservers` group (fixed by switching to `hosts: all`). Running the playbook installs the `vsftpd` package, starts the `vsftpd` service, and enables it on boot across all three application servers, with the `thor` user able to execute the playbook directly on the Jump Host.
