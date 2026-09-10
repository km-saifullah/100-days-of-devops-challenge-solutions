# Ansible Passwordless SSH Authentication and Connectivity

## Overview

In this task, the Jump Host is used as the Ansible controller. The `thor` user on the Jump Host is responsible for running Ansible commands against the application servers in the Stratos Data Center.

Before Ansible playbooks can be executed, passwordless SSH authentication must be configured between the Ansible controller and all managed application servers.

The required SSH connections are

- Jump Host `thor` → App Server 1 `tony`
- Jump Host `thor` → App Server 2 `steve`
- Jump Host `thor` → App Server 3 `banner`

After configuring SSH key-based authentication, the Ansible inventory is configured with the appropriate remote user and SSH private key. Finally, Ansible ping is used to verify connectivity to all application servers.

## Objective

- Configure passwordless SSH from the Jump Host to all application servers
- Use the correct remote user for each application server
- Configure the Ansible inventory
- Verify SSH connectivity
- Test Ansible connectivity using the `ping` module

## Environment

| Component          | Details                        |
| ------------------ | ------------------------------ |
| Ansible Controller | Jump Host                      |
| Controller User    | `thor`                         |
| App Server 1       | `stapp01`                      |
| App Server 1 User  | `tony`                         |
| App Server 2       | `stapp02`                      |
| App Server 2 User  | `steve`                        |
| App Server 3       | `stapp03`                      |
| App Server 3 User  | `banner`                       |
| SSH Key            | `/home/thor/.ssh/id_ed25519`   |
| Inventory          | `/home/thor/ansible/inventory` |

## Step 1: Verify the SSH Key

The private and public SSH keys are stored on the Jump Host under the `thor` user's SSH directory.

```bash
ls -l /home/thor/.ssh/id_ed25519*
```

If the key does not exist, it can be generated using:

```bash
ssh-keygen -t ed25519 -f /home/thor/.ssh/id_ed25519 -N ""
```

## Step 2: Configure SSH Authentication for App Server 1

The public key is copied to the `tony` user's account on App Server 1.

```bash
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub tony@stapp01
```

The connection is then tested using

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes tony@stapp01
```

The connection should work without requesting the user's password.

## Step 3: Configure SSH Authentication for App Server 2

The public key is copied to the `steve` user's account on App Server 2.

```bash
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub steve@stapp02
```

The connection is tested using

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes steve@stapp02
```

The connection should work without a password prompt.

## Step 4: Configure SSH Authentication for App Server 3

The public key is copied to the `banner` user's account on App Server 3.

```bash
ssh-copy-id -i /home/thor/.ssh/id_ed25519.pub banner@stapp03
```

The connection is tested using

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes banner@stapp03
```

The connection should work without a password prompt.

## Step 5: Verify SSH Connections

Each application server can be tested from the Jump Host.

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes tony@stapp01 "hostname && whoami"
```

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes steve@stapp02 "hostname && whoami"
```

```bash
ssh -i /home/thor/.ssh/id_ed25519 -o IdentitiesOnly=yes banner@stapp03 "hostname && whoami"
```

## Step 6: Configure the Ansible Inventory

The inventory file is located at

```text
/home/thor/ansible/inventory
```

The inventory contains the three application servers and their respective SSH users.

```ini
[appservers]
stapp01 ansible_host=stapp01 ansible_user=tony ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp02 ansible_host=stapp02 ansible_user=steve ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
stapp03 ansible_host=stapp03 ansible_user=banner ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
```

The `ansible_user` value is important because each managed server uses a different user account.

## Step 7: Verify the Inventory

The inventory can be inspected using

```bash
ansible-inventory -i /home/thor/ansible/inventory --list
```

Individual hosts can also be checked:

```bash
ansible-inventory -i /home/thor/ansible/inventory --host stapp01
```

```bash
ansible-inventory -i /home/thor/ansible/inventory --host stapp02
```

```bash
ansible-inventory -i /home/thor/ansible/inventory --host stapp03
```

## Step 8: Test Ansible Connectivity

Each application server can be tested individually.

```bash
ansible -i /home/thor/ansible/inventory stapp01 -m ping
```

```bash
ansible -i /home/thor/ansible/inventory stapp02 -m ping
```

```bash
ansible -i /home/thor/ansible/inventory stapp03 -m ping
```

Finally, all application servers can be tested together

```bash
ansible -i /home/thor/ansible/inventory appservers -m ping
```

## Final Validation

The complete task can be validated with

```bash
cd /home/thor/ansible
ansible -i inventory appservers -m ping
```

## Conclusion

The passwordless SSH authentication and Ansible connectivity requirements were completed. The required SSH configuration and inventory were set up for the application servers, and connectivity was verified successfully.
