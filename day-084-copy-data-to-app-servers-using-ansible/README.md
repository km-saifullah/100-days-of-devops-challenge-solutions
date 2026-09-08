# Ansible File Deployment to All Stratos Application Servers

## Overview

This task demonstrates how to use Ansible to deploy a file from a jump host to multiple application servers in the Stratos Data Center.

The objective was to configure all three application servers as Ansible managed nodes and create a playbook that copies the `index.html` file from the Ansible control node to `/opt/itadmin/index.html` on every application server.

## Objective

The task required the following:

- Create `/home/thor/ansible/inventory`
- Add all Stratos application servers to the inventory
- Configure SSH connectivity from the jump host to all managed nodes
- Create `/home/thor/ansible/playbook.yml`
- Copy `/usr/src/itadmin/index.html` from the jump host to all application servers
- Store the file as `/opt/itadmin/index.html`
- Ensure the playbook runs successfully without additional arguments

## Environment

The Ansible control node is the jump host.

The managed nodes are

| Server       | Hostname  | Remote User |
| ------------ | --------- | ----------- |
| App Server 1 | `stapp01` | `tony`      |
| App Server 2 | `stapp02` | `steve`     |
| App Server 3 | `stapp03` | `banner`    |

## SSH Configuration

Ansible requires connectivity from the jump host to each managed node.

A dedicated ED25519 SSH key pair was created on the jump host:

```bash
ssh-keygen -t ed25519 -f /home/thor/.ssh/id_ed25519 -N ""
```

The resulting files are

```text
/home/thor/.ssh/id_ed25519
/home/thor/.ssh/id_ed25519.pub
```

The public key was added to the appropriate `authorized_keys` file on each application server.

The SSH configuration allows the jump host to connect without requiring a password during Ansible execution.

## SSH Verification

Each server should be tested individually.

### App Server 1

```bash
ssh -i /home/thor/.ssh/id_ed25519 tony@stapp01
```

### App Server 2

```bash
ssh -i /home/thor/.ssh/id_ed25519 steve@stapp02
```

### App Server 3

```bash
ssh -i /home/thor/.ssh/id_ed25519 banner@stapp03
```

Each connection should succeed without a password prompt.

## Inventory Configuration

The inventory file is

```text
/home/thor/ansible/inventory
```

The final configuration is

```ini
[appservers]
stapp01 ansible_host=stapp01 ansible_user=tony ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp02 ansible_host=stapp02 ansible_user=steve ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp03 ansible_host=stapp03 ansible_user=banner ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
```

The `appservers` group allows the playbook to target all application servers at once. `ansible_user` specifies the SSH account for each server, while `ansible_ssh_private_key_file` specifies the private key used for authentication.

## Inventory Validation

The inventory can be inspected using

```bash
ansible-inventory -i inventory --list
```

## Ansible Connectivity Test

Before running the deployment, connectivity should be verified

```bash
ansible -i inventory appservers -m ping
```

## Playbook

The playbook is stored at

```text
/home/thor/ansible/playbook.yml
```

The complete playbook is

```yaml
---
- name: Deploy itadmin index page to all application servers
  hosts: appservers
  become: true

  tasks:
    - name: Create itadmin directory
      ansible.builtin.file:
        path: /opt/itadmin
        state: directory
        mode: "0755"

    - name: Copy index.html to application servers
      ansible.builtin.copy:
        src: /usr/src/itadmin/index.html
        dest: /opt/itadmin/index.html
        mode: "0644"
```

## Deployment

Run the playbook from the Ansible directory

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

## Verification

After deployment, verify the file on all servers

```bash
ansible -i inventory appservers -b -m command -a "ls -l /opt/itadmin/index.html"
```

The file contents can be checked using

```bash
ansible -i inventory appservers -b -m command -a "cat /opt/itadmin/index.html"
```

The content should match the source file on the jump host

```bash
cat /usr/src/itadmin/index.html
```

## SSH Troubleshooting

### Permission Denied

If Ansible reports

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)
```

verify the SSH key

```bash
ls -la /home/thor/.ssh/
```

The private key should exist

```text
id_ed25519
```

Test the affected server directly

```bash
ssh -i /home/thor/.ssh/id_ed25519 <user>@<server>
```

### Missing authorized_keys

On the affected application server

```bash
ls -la ~/.ssh/
```

Verify

```text
authorized_keys
```

The recommended permissions are

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

The SSH directory should also belong to the appropriate remote user.

### Test All Managed Nodes

A single Ansible command can verify all SSH connections

```bash
ansible -i inventory appservers -m ping
```

Do not proceed with the deployment until all managed nodes return `SUCCESS`.

## Main Takeaways

- Ansible inventories define the managed nodes used by playbooks
- All three Stratos application servers can be grouped under a single inventory group
- SSH key authentication allows Ansible to operate without additional password or key arguments
- `ansible_ssh_private_key_file` can define the SSH private key directly in the inventory
- The `ansible.builtin.copy` module transfers files from the Ansible controller to managed nodes
- Creating the destination directory before copying avoids failures when the parent directory does not exist
- Privilege escalation is required when the remote destination requires elevated permissions
- Testing SSH and Ansible connectivity before running the deployment makes troubleshooting much easier

## Conclusion

The Ansible inventory was configured with all Stratos application servers, SSH key-based connectivity was established, and a playbook was created to deploy the required `index.html` file to `/opt/itadmin` on every application server. The required configuration and deployment workflow were successfully set up and verified.
