# Ansible HTTPD Web Server and Sample Page

## Task Overview

The Nautilus DevOps team requires a simple Apache HTTPD web server to be installed and configured on all application servers in the Stratos Datacenter.

The existing Ansible inventory is already available on the Jump Host at

```text
/home/thor/ansible/inventory
```

The required playbook must be created at

```text
/home/thor/ansible/playbook.yml
```

The playbook must work with the exact validation command

```bash
ansible-playbook -i inventory playbook.yml
```

No additional arguments should be required.

## Server Information

| Server                         | Hostname    | User     |
| ------------------------------ | ----------- | -------- |
| Jump Host / Ansible Controller | `jump-host` | `thor`   |
| App Server 1                   | `stapp01`   | `tony`   |
| App Server 2                   | `stapp02`   | `steve`  |
| App Server 3                   | `stapp03`   | `banner` |

## Step 1: Access the Jump Host

All Ansible commands should be executed on the Jump Host using the `thor` user.

Run

```bash
cd /home/thor/ansible
```

Check the existing inventory

```bash
cat inventory
```

The inventory should contain all application servers.

## Step 2: Test Ansible Connectivity

Before running the playbook, test connectivity from the Jump Host to all application servers

```bash
ansible -i inventory all -m ping
```

The managed servers should return

```text
SUCCESS
```

If Ansible cannot connect, resolve the SSH authentication issue before continuing.

## SSH Troubleshooting

If you receive

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)
```

check the SSH keys on the Jump Host

```bash
ls -la /home/thor/.ssh/
```

If `id_ed25519` and `id_ed25519.pub` do not exist, create an SSH key as `thor`:

```bash
ssh-keygen -t ed25519
```

Press Enter through the prompts.

Copy the public key to the application servers

```bash
ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
```

Test each connection:

```bash
ssh tony@stapp01
```

Then

```bash
exit
```

Test App Server 2

```bash
ssh steve@stapp02
```

Then

```bash
exit
```

Test App Server 3

```bash
ssh banner@stapp03
```

Then

```bash
exit
```

Finally test Ansible again

```bash
ansible -i inventory all -m ping
```

## Step 3: Create the Ansible Playbook

On the Jump Host

```bash
cd /home/thor/ansible
vi playbook.yml
```

Use the following complete playbook

```yaml
---
- name: Install and configure httpd on all app servers
  hosts: all
  become: true

  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: Start and enable httpd
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true

    - name: Create index.html with initial content
      ansible.builtin.copy:
        dest: /var/www/html/index.html
        content: "This is a Nautilus sample file, created using Ansible!\n"
        owner: apache
        group: apache
        mode: "0755"

    - name: Add welcome message at the top of index.html
      ansible.builtin.lineinfile:
        path: /var/www/html/index.html
        line: "Welcome to Nautilus Group!"
        insertbefore: BOF
        state: present

    - name: Set index.html ownership
      ansible.builtin.file:
        path: /var/www/html/index.html
        owner: apache
        group: apache

    - name: Set index.html permissions
      ansible.builtin.file:
        path: /var/www/html/index.html
        mode: "0755"
```

## Step 4: Understand the Playbook

The playbook runs against

```yaml
hosts: all
```

Therefore, every server listed in the existing inventory will be managed.

The playbook uses

```yaml
become: true
```

because installing packages, managing services and writing to `/var/www/html` require elevated privileges.

## Step 5: Install HTTPD

The following task installs Apache HTTPD

```yaml
- name: Install httpd
  ansible.builtin.yum:
    name: httpd
    state: present
```

Using

```yaml
state: present
```

makes the task idempotent and safe to execute repeatedly.

## Step 6: Start and Enable HTTPD

The following task makes sure the service is both running and enabled

```yaml
- name: Start and enable httpd
  ansible.builtin.service:
    name: httpd
    state: started
    enabled: true
```

`state: started` ensures that HTTPD is currently running.

`enabled: true` ensures that HTTPD starts automatically after a server reboot.

## Step 7: Create index.html

The initial web page is created using the Ansible `copy` module:

```yaml
- name: Create index.html with initial content
  ansible.builtin.copy:
    dest: /var/www/html/index.html
    content: "This is a Nautilus sample file, created using Ansible!\n"
    owner: apache
    group: apache
    mode: "0755"
```

This creates

```text
/var/www/html/index.html
```

with the required content.

## Step 8: Add the New Line at the Top

The requirement says

```text
Welcome to Nautilus Group!
```

must be added at the beginning of the file.

The playbook uses

```yaml
- name: Add welcome message at the top of index.html
  ansible.builtin.lineinfile:
    path: /var/www/html/index.html
    line: "Welcome to Nautilus Group!"
    insertbefore: BOF
    state: present
```

`BOF` means Beginning Of File.

Therefore, the final file should contain:

```text
Welcome to Nautilus Group!
This is a Nautilus sample file, created using Ansible!
```

## Step 9: Set Ownership

The requirement is that the web page must be owned by:

```text
apache:apache
```

The playbook uses:

```yaml
- name: Set index.html ownership
  ansible.builtin.file:
    path: /var/www/html/index.html
    owner: apache
    group: apache
```

## Step 10: Set Permissions

The required permissions are

The playbook sets them using

```yaml
- name: Set index.html permissions
  ansible.builtin.file:
    path: /var/www/html/index.html
    mode: "0755"
```

`0755` corresponds to

```text
rwxr-xr-x
```

## Step 11: Check Playbook Syntax

Run on the Jump Host

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml --syntax-check
```

Expected output

```text
playbook: playbook.yml
```

## Step 12: Run the Playbook

Run the exact command that the validation system will use

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

The playbook should complete successfully on all application servers.

## Step 13: Verify HTTPD Service

Run from the Jump Host

```bash
ansible -i inventory all -m shell -a "systemctl is-active httpd"
```

Expected Output

```text
active
```

for every application server.

Check that HTTPD is enabled

```bash
ansible -i inventory all -m shell -a "systemctl is-enabled httpd"
```

Expected Output

```text
enabled
```

## Step 14: Verify Website Content

Run

```bash
ansible -i inventory all -m shell -a "cat /var/www/html/index.html"
```

Expected Output

```text
Welcome to Nautilus Group!
This is a Nautilus sample file, created using Ansible!
```

## Step 15 Verify Ownership

Run:

```bash
ansible -i inventory all -m shell -a "ls -l /var/www/html/index.html"
```

## Step 16: Verify Permissions

Verify using

```bash
ansible -i inventory all -m shell -a "stat -c '%a %U %G %n' /var/www/html/index.html"
```

## Common Troubleshooting

### HTTPD package installation fails

Check connectivity

```bash
ansible -i inventory all -m ping
```

Then check the operating system

```bash
ansible -i inventory all -m shell -a "cat /etc/os-release"
```

Check enabled repositories

```bash
ansible -i inventory all -m shell -a "yum repolist"
```

### HTTPD service is not running

Check the service

```bash
ansible -i inventory all -m shell -a "systemctl status httpd --no-pager"
```

Check recent service logs

```bash
ansible -i inventory all -m shell -a "journalctl -u httpd --no-pager -n 50"
```

The playbook already contains

```yaml
state: started
enabled: true
```

so rerunning the playbook should start and enable the service.

### `lineinfile` adds the line incorrectly

Make sure the task contains

```yaml
insertbefore: BOF
```

and

```yaml
state: present
```

`BOF` ensures the line is inserted at the beginning of the file, while `state: present` prevents duplicate lines during repeated executions.

## Final Validation Command

The most important command for this task is

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

No additional arguments should be required.

## Conclusion

The Apache HTTPD web server and required sample webpage have been configured on all Nautilus application servers using Ansible. The playbook is designed to work with the existing inventory and the required validation command without additional arguments.
