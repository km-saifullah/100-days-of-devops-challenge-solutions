# Ansible Remote File Creation with Custom Ownership and Permissions

## Overview

The Nautilus DevOps team is testing Ansible file-management capabilities across the application servers in the Stratos Data Center.

The objective of this task is to use Ansible to create a blank file named `/usr/src/web.txt` on all application servers while applying specific permissions and ownership requirements.

## Objectives

The task has four primary requirements:

1. Create an Ansible inventory at `~/playbook/inventory`.
2. Include all three application servers as managed nodes.
3. Create `/usr/src/web.txt` on every application server.
4. Configure the file with permissions `0744` and server-specific ownership.

The required ownership is

| Application Server | Hostname  | Owner    | Group    |
| ------------------ | --------- | -------- | -------- |
| App Server 1       | `stapp01` | `tony`   | `tony`   |
| App Server 2       | `stapp02` | `steve`  | `steve`  |
| App Server 3       | `stapp03` | `banner` | `banner` |

## SSH Configuration

Ansible requires reliable SSH connectivity to every managed node.

The SSH key pair on the jump host can be created using

```bash
ssh-keygen -t ed25519 -f /home/thor/.ssh/id_ed25519 -N ""
```

The public key should then be installed in the appropriate user's `authorized_keys` file on each application server.

For example

```bash
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub tony@stapp01
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub steve@stapp02
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub banner@stapp03
```

Passwordless SSH should be verified individually:

```bash
ssh -i /home/thor/.ssh/id_ed25519 tony@stapp01
ssh -i /home/thor/.ssh/id_ed25519 steve@stapp02
ssh -i /home/thor/.ssh/id_ed25519 banner@stapp03
```

Each connection should succeed without requiring a password.

## SSH Permission Requirements

On each application server, the SSH directory should have appropriate permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

The `.ssh` directory and `authorized_keys` file should be owned by the corresponding remote user.

For example, on App Server 3:

```bash
chown -R banner:banner /home/banner/.ssh
```

## Inventory Configuration

The inventory is located at

```text
~/playbook/inventory
```

The complete inventory is

```ini
[appservers]
stapp01 ansible_host=stapp01 ansible_user=tony ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp02 ansible_host=stapp02 ansible_user=steve ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp03 ansible_host=stapp03 ansible_user=banner ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
```

The `appservers` group allows the playbook to target all application servers together.

The `ansible_user` variable identifies the remote SSH user for each server.

The `ansible_ssh_private_key_file` variable explicitly specifies the private key used for authentication.

## Inventory Validation

The inventory can be inspected with

```bash
ansible-inventory -i inventory --list
```

All three hosts should be present

```text
stapp01
stapp02
stapp03
```

## Ansible Connectivity Test

Before executing the playbook, SSH connectivity should be tested using

```bash
ansible -i inventory appservers -m ping
```

A successful result should report

```text
stapp01 | SUCCESS
stapp02 | SUCCESS
stapp03 | SUCCESS
```

If any host returns `UNREACHABLE`, the SSH configuration should be fixed before running the playbook.

## Privilege Escalation

The destination file is

```text
/usr/src/web.txt
```

The remote SSH users generally do not have permission to create files directly under `/usr/src`.

Therefore, the playbook uses

```yaml
become: true
```

This allows Ansible to perform the file operation with elevated privileges.

Privilege escalation should be tested with

```bash
ansible -i inventory appservers -b -m command -a "whoami"
```

The expected result is `root` for each application server.

## Playbook

The playbook is stored at

```text
~/playbook/playbook.yml
```

The complete playbook is

```yaml
---
- name: Create web.txt on all application servers
  hosts: appservers
  become: true

  tasks:
    - name: Create blank web.txt with required ownership and permissions
      ansible.builtin.file:
        path: /usr/src/web.txt
        state: touch
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: "0744"
```

## Playbook Explanation

The playbook targets the `appservers` group, which contains all three application servers.

The `become: true` setting allows the playbook to create and configure a file under `/usr/src`.

The `ansible.builtin.file` module is used because it can create files and manage their ownership and permissions. The `touch` state creates an empty file if the file does not already exist.

The ownership is dynamically determined from the inventory

```yaml
owner: "{{ ansible_user }}"
group: "{{ ansible_user }}"
```

This produces the following configuration automatically

```text
stapp01 → tony:tony
stapp02 → steve:steve
stapp03 → banner:banner
```

The file mode is explicitly defined as

```yaml
mode: "0744"
```

The quotes around `0744` are intentional and prevent YAML from interpreting the value incorrectly.

## Deployment

From the jump host

```bash
cd ~/playbook
ansible-playbook -i inventory playbook.yml
```

This is also the exact command used by the validation process

The expected playbook result is

```text
PLAY [Create web.txt on all application servers]

TASK [Gathering Facts]
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [Create blank web.txt with required ownership and permissions]
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]
```

The final recap should contain

```text
unreachable=0
failed=0
```

## Verification

The resulting files can be checked on all application servers with:

```bash
ansible -i inventory appservers -b -m command -a "ls -l /usr/src/web.txt"
```

The expected ownership should be equivalent to

```text
stapp01 → tony   tony
stapp02 → steve  steve
stapp03 → banner banner
```

The permissions should be

```text
-rwxr--r--
```

## Troubleshooting

### SSH Key Missing

Check

```bash
ls -la /home/thor/.ssh/
```

The following files should exist

```text
id_ed25519
id_ed25519.pub
```

### SSH Authentication Failure

Test the affected host directly

```bash
ssh -i /home/thor/.ssh/id_ed25519 <user>@<host>
```

### SSH Permission Problems

On the affected application server

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Ensure the files belong to the correct user.

## Main Takeaways

- Ansible inventory defines all managed application servers
- SSH key authentication allows the playbook to execute without additional connection arguments
- Each application server can use a different SSH username
- The `ansible.builtin.file` module can create files and manage permissions and ownership
- `state: touch` creates an empty file when it does not exist
- `mode: '0744'` explicitly defines the required permissions
- Inventory variables can be reused inside a playbook through `ansible_user`
- `become: true` is appropriate when the remote task requires elevated privileges
- Testing SSH and Ansible connectivity before executing the playbook makes troubleshooting easier

## Conclusion

The Ansible inventory was configured with all application servers, SSH key-based access was established, and the playbook was created to generate the required blank file with the specified permissions and server-specific ownership. The required configuration was successfully set up and verified.
