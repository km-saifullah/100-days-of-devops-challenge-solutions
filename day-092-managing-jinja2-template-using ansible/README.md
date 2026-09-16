# Ansible HTTPD Role and Jinja2 Template

## Task Overview

The Nautilus DevOps team is working on an Ansible role for HTTPD installation and configuration.

The existing HTTPD role is already available on the Jump Host. The requirement is to complete the role by adding a Jinja2 template for the `index.html` file and adding the required task to deploy that template on App Server 1.

The existing Ansible inventory is already available on the Jump Host at

```text
/home/thor/ansible/inventory
```

The required playbook is located at

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

For this challenge, the HTTPD role must run only on **App Server 1 (`stapp01`)**.

## Step 1: Access the Jump Host

All Ansible commands should be executed on the Jump Host using the `thor` user.

Run

```bash
cd /home/thor/ansible
```

Check the existing directory structure

```bash
tree
```

The Ansible directory should contain the existing HTTPD role

```text
.
├── ansible.cfg
├── inventory
├── playbook.yml
└── role
    └── httpd
        ├── README.md
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml
```

## Step 2: Check the Existing Inventory

Check the existing inventory

```bash
cat inventory
```

The inventory contains

```text
stapp01 ansible_host=stapp01 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=stapp02 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=stapp03 ansible_ssh_pass=BigGr33n ansible_user=banner
```

The important detail for this challenge is that App Server 1 uses the Ansible user:

```text
tony
```

## Step 3: Test Ansible Connectivity

Before running the playbook, test connectivity to App Server 1

```bash
ansible -i inventory stapp01 -m ping
```

Expected output should contain

```text
SUCCESS
```

If Ansible cannot connect, resolve the SSH authentication issue before continuing.

You can also test all application servers

```bash
ansible -i inventory all -m ping
```

## Step 4: Check the Existing Playbook

Check the existing playbook

```bash
cat playbook.yml
```

The playbook needs to be updated so that the HTTPD role runs on App Server 1 only.

## Step 5: Update the Ansible Playbook

Edit the playbook

```bash
vi playbook.yml
```

Use the following complete playbook

```yaml
---
- hosts: stapp01
  become: yes
  become_user: root
  roles:
    - role/httpd
```

The important change is

```yaml
hosts: stapp01
```

This ensures that the HTTPD role is executed only against App Server 1.

The role is loaded using

```yaml
roles:
  - role/httpd
```

Privilege escalation is enabled because HTTPD installation and writing to `/var/www/html` require root privileges.

## Step 6: Check the Existing HTTPD Role

Check the existing role tasks

```bash
cat role/httpd/tasks/main.yml
```

The role already contains the HTTPD installation and configuration tasks.

Do not remove the existing tasks.

The new Jinja2 template deployment task should be added to the existing role.

## Step 7: Create the Jinja2 Template

The template must be created inside

```text
/home/thor/ansible/role/httpd/templates/
```

Create the template

```bash
vi role/httpd/templates/index.html.j2
```

Add

```jinja2
This file was created using Ansible on {{ inventory_hostname }}
```

## Step 8: Do Not Hard-Code the Server Name

The server name must not be hard-coded inside the Jinja2 template.

```jinja2
This file was created using Ansible on {{ inventory_hostname }}
```

Using `inventory_hostname` makes the template reusable for other inventory hosts as well.

## Step 9: Add the Template Task to the HTTPD Role

Edit the existing role task file

```bash
vi role/httpd/tasks/main.yml
```

Keep all existing tasks and add the following task

```yaml
- name: Deploy index.html from Jinja2 template
  ansible.builtin.template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: "0777"
```

The `template` module copies the Jinja2 template to the remote server and processes the Ansible variables before creating the final file.

## Step 10: Understand the Template Source

The following configuration

```yaml
src: index.html.j2
```

tells Ansible to look for

```text
role/httpd/templates/index.html.j2
```

The template is processed before it is copied to the target server.

For App Server 1

```text
{{ inventory_hostname }}
```

becomes:

```text
stapp01
```

## Step 11: Configure the Destination

The destination is

```yaml
dest: /var/www/html/index.html
```

Therefore, after the playbook runs, the generated file will be located at

```text
/var/www/html/index.html
```

on App Server 1.

## Step 12: Configure File Ownership

The requirement states that the file owner and group must be the respective sudo/Ansible user of the server.

The task uses

```yaml
owner: "{{ ansible_user }}"
group: "{{ ansible_user }}"
```

For App Server 1, the inventory defines

```text
ansible_user=tony
```

Therefore, the resulting ownership will be

```text
tony:tony
```

This avoids hard-coding the username in the role task.

## Step 13: Configure File Permissions

The requirement specifies that

```text
/var/www/html/index.html
```

must have permissions

```text
0777
```

## Step 14: Final Role Structure

After completing the changes, the relevant role structure should look like

```text
/home/thor/ansible/
├── ansible.cfg
├── inventory
├── playbook.yml
└── role
    └── httpd
        ├── README.md
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        ├── templates
        │   └── index.html.j2
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml
```

## Step 15: Check the Jinja2 Template

Verify the template:

```bash
cat role/httpd/templates/index.html.j2
```

Expected content

```jinja2
This file was created using Ansible on {{ inventory_hostname }}
```

## Step 16: Check the Playbook Syntax

Run the syntax check

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml --syntax-check
```

Expected output

```text
playbook: playbook.yml
```

## Step 17: Run the Playbook

Run the exact command that the validation system will use

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

No additional arguments should be required.

The playbook should execute the existing HTTPD role against

```text
stapp01
```

and deploy the Jinja2-generated `index.html`.

## Step 18: Verify the Generated File

After the playbook completes, connect to App Server 1

```bash
ssh tony@stapp01
```

Check the generated file

```bash
cat /var/www/html/index.html
```

Expected output

```text
This file was created using Ansible on stapp01
```

## Step 19: Verify File Ownership

Run

```bash
ls -l /var/www/html/index.html
```

The owner and group should be

```text
tony tony
```

## Step 20: Verify File Permissions

Run

```bash
stat -c '%a %U %G %n' /var/www/html/index.html
```

Expected output

```text
777 tony tony /var/www/html/index.html
```

## Step 21: Verify HTTPD

Verify that HTTPD is running

```bash
systemctl is-active httpd
```

Expected output

```text
active
```

If required, verify that HTTPD is enabled

```bash
systemctl is-enabled httpd
```

## Common Troubleshooting

### Ansible Cannot Connect to stapp01

Test connectivity

```bash
ansible -i inventory stapp01 -m ping
```

Check the SSH connection directly

```bash
ssh tony@stapp01
```

If SSH authentication fails, resolve the authentication issue before running the playbook.

### Template Not Found

If Ansible reports that `index.html.j2` cannot be found, verify the template location:

```bash
ls -l /home/thor/ansible/role/httpd/templates/
```

The file must be named exactly

```text
index.html.j2
```

### Server Name Is Incorrect

Check the template

```bash
cat /home/thor/ansible/role/httpd/templates/index.html.j2
```

It must use

```jinja2
{{ inventory_hostname }}
```

Do not hard-code

```text
stapp01
```

inside the template.

### Incorrect File Ownership

Check the inventory

```bash
cat inventory
```

App Server 1 should contain

```text
ansible_user=tony
```

The template task should use

```yaml
owner: "{{ ansible_user }}"
group: "{{ ansible_user }}"
```

### Incorrect File Permissions

Check

```bash
stat -c '%a %U %G %n' /var/www/html/index.html
```

The permission value must be

```text
777
```

The task should contain

```yaml
mode: "0777"
```

### Playbook Runs on the Wrong Servers

Check

```bash
cat playbook.yml
```

The play must target

```yaml
hosts: stapp01
```

It should not use

```yaml
hosts: all
```

because this challenge specifically requires the HTTPD role to run on App Server 1.

## Conclusion

The HTTPD role was updated with the required Jinja2 template and deployment task, and the required configuration was successfully set up and verified.
