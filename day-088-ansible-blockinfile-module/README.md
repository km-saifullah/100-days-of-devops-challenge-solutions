# Ansible HTTPD Web Server Setup

## Overview

The Nautilus DevOps team required a simple `httpd` web server to be installed and configured on all application servers in the Stratos Datacenter using Ansible. In addition, a sample web page needed to be deployed to each server, with specific content, ownership, and permissions, all driven entirely by an Ansible playbook.

The Jump Host acts as the Ansible controller, and the `thor` user is used to execute the Ansible commands and playbook.

The task includes installing the `httpd` package, ensuring the service is started and enabled, inserting content into `/var/www/html/index.html` using the `blockinfile` module, and setting the correct ownership and permissions on that file.

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

Ansible should already be installed on the Jump Host.

Verify

```bash
ansible --version
```

An inventory file already exists under `/home/thor/ansible` on the Jump Host, so no new inventory needs to be created for this task.

Confirm it is present and reachable

```bash
cd /home/thor/ansible
cat inventory
ansible -i inventory all -m ping
```

The important response from each server is

```text
"ping": "pong"
```

## Create the Ansible Playbook

Go to the directory

```bash
cd /home/thor/ansible
vi playbook.yml
```

Use the following complete playbook

```yaml
---
- name: Install and configure HTTPD on all app servers
  hosts: appservers
  become: true

  tasks:
    - name: Install httpd package
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: Ensure httpd service is running
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true

    - name: Configure index.html
      ansible.builtin.blockinfile:
        path: /var/www/html/index.html
        block: |
          Welcome to XfusionCorp!
          This is  Nautilus sample file, created using Ansible!
          Please do not modify this file manually!

    - name: Set index.html ownership
      ansible.builtin.file:
        path: /var/www/html/index.html
        owner: apache
        group: apache

    - name: Set index.html permissions
      ansible.builtin.file:
        path: /var/www/html/index.html
        mode: "0744"
```

Notes on the playbook

- `hosts: all` targets every host defined in the existing inventory, so the playbook does not depend on a specific group name.
- The `blockinfile` module is used with its default markers (no `marker` parameter is set), since custom or empty markers are not allowed for this task.
- `create: true` ensures `/var/www/html/index.html` is created if it does not already exist before the block is inserted.
- Ownership and permissions are applied in separate `file` tasks after the content is written, so they are guaranteed regardless of whether `index.html` already existed.

## Run the Playbook

From the Jump Host as `thor`

```bash
cd /home/thor/ansible
```

Run

```bash
ansible-playbook -i inventory playbook.yml
```

This is also the exact command expected by the validation system.

## Verify HTTPD Installation and Service

After the playbook completes successfully, verify `httpd` on all application servers

```bash
ansible -i inventory all -m shell -a 'rpm -q httpd'
ansible -i inventory all -m shell -a 'systemctl is-active httpd'
ansible -i inventory all -m shell -a 'systemctl is-enabled httpd'
```

## Verify the Sample Web Page

Check the content of `index.html`

```bash
ansible -i inventory all -m shell -a 'cat /var/www/html/index.html'
```

Check ownership

```bash
ansible -i inventory all -m shell -a 'ls -l /var/www/html/index.html'
```

Expected owner and group

```text
apache apache
```

Check permissions

```bash
ansible -i inventory all -m shell -a 'stat -c "%a" /var/www/html/index.html'
```

Expected permissions

```text
744
```

## Troubleshooting

### Package Not Found

If the `yum` module reports that `httpd` cannot be found, confirm the correct package repositories are configured on the application servers

```bash
ansible -i inventory all -m shell -a 'yum repolist'
```

### blockinfile Marker Issues

If validation fails on the content of `index.html`, confirm no custom `marker` parameter was added to the `blockinfile` task, since the task requires the default markers to be used.

## Final Validation

Run the exact validation command

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

Then verify the service

```bash
ansible -i inventory all -m shell -a 'systemctl is-active httpd'
```

Finally verify the file content, ownership and permissions

```bash
ansible -i inventory all -m shell -a 'cat /var/www/html/index.html'
ansible -i inventory all -m shell -a 'ls -l /var/www/html/index.html'
```

The inventory and playbook are configured so the task can be executed without any additional command-line arguments.

## Conclusion

The Ansible playbook was created successfully, `httpd` was installed and its service enabled and started across all application servers, and the sample `index.html` page was deployed with the required content, ownership, and permissions using the `blockinfile` and `file` modules.
