# Ansible Finance Files with ACL Permissions

## Overview

The Nautilus DevOps team requires specific files to be created on each application server in the Stratos Datacenter, owned by `root`, but with an additional access control list (ACL) entry granting a designated app-specific user or group extra permissions. All of this must be done using Ansible only.

The Jump Host acts as the Ansible controller, and the `thor` user is used to execute the Ansible commands and playbook.

The task includes fixing SSH connectivity to all three application servers, using the existing Ansible inventory, and creating a playbook that creates one file per server under `/opt/finance/`, each owned by `root`, with a specific ACL entry applied using the `ansible.posix.acl` module.

## Infrastructure

| Server               | Hostname    | SSH User | SSH Auth | File to Create           | ACL Grant                          |
| -------------------- | ----------- | -------- | -------- | ------------------------ | ---------------------------------- |
| Application Server 1 | `stapp01`   | `tony`   | Password | `/opt/finance/blog.txt`  | group `tony` — read (`r`)          |
| Application Server 2 | `stapp02`   | `steve`  | Password | `/opt/finance/story.txt` | user `steve` — read/write (`rw`)   |
| Application Server 3 | `stapp03`   | `banner` | Password | `/opt/finance/media.txt` | group `banner` — read/write (`rw`) |
| Jump Host            | `jump-host` | `thor`   | -        | -                        | -                                  |

## Existing Ansible Inventory

The inventory file already exists on the Jump Host at

```text
/home/thor/ansible/inventory
```

It uses password authentication via `ansible_ssh_pass` and is a flat list with no group header

```bash
cat inventory
```

```ini
stapp01 ansible_host=stapp01 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=stapp02 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=stapp03 ansible_ssh_pass=BigGr33n ansible_user=banner
```

No changes are made to the inventory. Since there is no `[appservers]` group, the playbook targets each server directly by its inventory hostname (`stapp01`, `stapp02`, `stapp03`) in separate plays.

## Fix SSH Connectivity to All Application Servers

### Prerequisite: sshpass

Because the inventory uses `ansible_ssh_pass`, `sshpass` must be installed on the Jump Host

```bash
sudo yum install -y sshpass
```

(use `sudo apt install -y sshpass` on a Debian/Ubuntu-based Jump Host)

### Trust All Three Host Keys

If SSH reports `Host key verification failed` for any server, add all three host keys to `known_hosts` in one step

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keyscan -H stapp01 stapp02 stapp03 >> ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
```

### Verify SSH to Each Server

```bash
sshpass -p 'Ir0nM@n' ssh tony@stapp01 'hostname'
sshpass -p 'Am3ric@' ssh steve@stapp02 'hostname'
sshpass -p 'BigGr33n' ssh banner@stapp03 'hostname'
```

Each command should return the corresponding hostname without any password or host-key prompt.

### Verify Ansible Connectivity to All Servers

```bash
cd /home/thor/ansible
ansible -i inventory all -m ping
```

All three servers should return

```text
"ping": "pong"
```

## Install the ACL Collection

The playbook uses the `ansible.posix.acl` module to manage file ACLs. This module comes from the `ansible.posix` collection, which may need to be installed on the Jump Host

```bash
ansible-galaxy collection install ansible.posix
```

Confirm it is available

```bash
ansible-galaxy collection list | grep posix
```

The `acl` package must also be present on each application server so `setfacl`/`getfacl` work; the module will fail with a clear error if it is missing, in which case install it via a `yum`/`package` task or manually with `sudo yum install -y acl` on each server.

## Create the Ansible Playbook

```bash
cd /home/thor/ansible
vi playbook.yml
```

Since each server needs a different filename and a different ACL entity/etype/permission combination, the playbook uses three separate plays, one per host, rather than a single play with a shared group.

Use the following complete playbook

```yaml
---
- name: Create blog.txt on Application Server 1 with ACL for group tony
  hosts: stapp01
  become: true

  tasks:
    - name: Ensure /opt/finance directory exists
      ansible.builtin.file:
        path: /opt/finance
        state: directory
        owner: root
        group: root
        mode: "0755"

    - name: Create empty blog.txt owned by root
      ansible.builtin.file:
        path: /opt/finance/blog.txt
        state: touch
        owner: root
        group: root
        mode: "0644"

    - name: Grant group tony read (r) permission via ACL
      ansible.posix.acl:
        path: /opt/finance/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: Create story.txt on Application Server 2 with ACL for user steve
  hosts: stapp02
  become: true

  tasks:
    - name: Ensure /opt/finance directory exists
      ansible.builtin.file:
        path: /opt/finance
        state: directory
        owner: root
        group: root
        mode: "0755"

    - name: Create empty story.txt owned by root
      ansible.builtin.file:
        path: /opt/finance/story.txt
        state: touch
        owner: root
        group: root
        mode: "0644"

    - name: Grant user steve read/write (rw) permission via ACL
      ansible.posix.acl:
        path: /opt/finance/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present

- name: Create media.txt on Application Server 3 with ACL for group banner
  hosts: stapp03
  become: true

  tasks:
    - name: Ensure /opt/finance directory exists
      ansible.builtin.file:
        path: /opt/finance
        state: directory
        owner: root
        group: root
        mode: "0755"

    - name: Create empty media.txt owned by root
      ansible.builtin.file:
        path: /opt/finance/media.txt
        state: touch
        owner: root
        group: root
        mode: "0644"

    - name: Grant group banner read/write (rw) permission via ACL
      ansible.posix.acl:
        path: /opt/finance/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
```

Each play does three things on its target host:

1. Ensures `/opt/finance` exists as a directory.
2. Creates the required file empty and owned by `root:root`.
3. Applies the requested ACL entry (`entity` + `etype` + `permissions`) using `ansible.posix.acl`, leaving the base ownership as `root` while granting the extra access.

Because `hosts:` in each play refers directly to the inventory hostname (`stapp01`, `stapp02`, `stapp03`), no group definition is needed in the inventory.

## Run the Playbook

From the Jump Host as `thor`

```bash
cd /home/thor/ansible
```

Run

```bash
ansible-playbook -i inventory playbook.yml
```

This is also the exact command expected by the validation system, so no extra arguments are required.

## Verify File Ownership and ACLs

Check that each file exists and is owned by `root`

```bash
ansible -i inventory stapp01 -m shell -a 'ls -l /opt/finance/blog.txt'
ansible -i inventory stapp02 -m shell -a 'ls -l /opt/finance/story.txt'
ansible -i inventory stapp03 -m shell -a 'ls -l /opt/finance/media.txt'
```

Check the ACL entries on each file

```bash
ansible -i inventory stapp01 -m shell -a 'getfacl /opt/finance/blog.txt'
ansible -i inventory stapp02 -m shell -a 'getfacl /opt/finance/story.txt'
ansible -i inventory stapp03 -m shell -a 'getfacl /opt/finance/media.txt'
```

Expected ACL lines

- `stapp01`: `group:tony:r--`
- `stapp02`: `user:steve:rw-`
- `stapp03`: `group:banner:rw-`

## Troubleshooting

### Host Key Verification Failed

```text
Host key verification failed.
```

Fix by adding the host keys as shown above

```bash
ssh-keyscan -H stapp01 stapp02 stapp03 >> ~/.ssh/known_hosts
```

### Module Not Found

```text
couldn't resolve module/action 'ansible.posix.acl'
```

Fix by installing the collection on the Jump Host

```bash
ansible-galaxy collection install ansible.posix
```

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

Finally verify the files and ACLs

```bash
ansible -i inventory stapp01 -m shell -a 'getfacl /opt/finance/blog.txt'
ansible -i inventory stapp02 -m shell -a 'getfacl /opt/finance/story.txt'
ansible -i inventory stapp03 -m shell -a 'getfacl /opt/finance/media.txt'
```

The inventory and playbook are configured so the task can be executed without any additional command-line arguments.

## Conclusion

SSH connectivity to all three application servers was restored by trusting their host keys and confirming password-based authentication with `sshpass`. The Ansible playbook was created at `/home/thor/ansible/playbook.yml`, using the existing inventory without modification. It creates `blog.txt`, `story.txt`, and `media.txt` under `/opt/finance/` on `stapp01`, `stapp02`, and `stapp03` respectively, each owned by `root`, with an ACL entry granting the requested app-specific user or group the required read or read/write access.
