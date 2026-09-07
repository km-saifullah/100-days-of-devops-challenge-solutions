# Ansible Inventory and File Creation on App Server 2

## What is the Challenge?

The Nautilus DevOps team needed to complete an Ansible configuration on the jump host. The existing inventory needed to be updated so that Ansible could connect to App Server 2 in the Stratos Data Center.

A playbook also needed to be created to generate an empty `/tmp/file.txt` file on App Server 2.

## Required Technology

The following technologies were used:

- Ansible
- Ansible Inventory
- SSH
- Linux
- YAML
- OpenSSH

## Step 1: Check the SSH Configuration

Initially, the jump host did not contain an SSH private key. The `.ssh` directory contained only

```text
known_hosts
known_hosts.old
```

Therefore, an SSH key pair was generated for the `thor` user.

## Step 2: Generate an SSH Key Pair

On the jump host

```bash
ssh-keygen -t ed25519 -f /home/thor/.ssh/id_ed25519 -N ""
```

This generated

```text
/home/thor/.ssh/id_ed25519
/home/thor/.ssh/id_ed25519.pub
```

The private key remains on the jump host while the public key is installed on App Server 2.

## Step 3: Configure Passwordless SSH

The public key was copied to App Server 2 for the `steve` user.

The SSH directory was configured with

```bash
mkdir -p /home/steve/.ssh
chmod 700 /home/steve/.ssh
```

The public key was added to

```text
/home/steve/.ssh/authorized_keys
```

The required permissions were applied

```bash
chmod 600 /home/steve/.ssh/authorized_keys
chown -R steve:steve /home/steve/.ssh
```

Passwordless SSH was then tested using

```bash
ssh -i /home/thor/.ssh/id_ed25519 steve@stapp02
```

The connection should succeed without requesting the user's password.

## Step 4: Configure the Ansible Inventory

The inventory file is

```text
/home/thor/ansible/inventory
```

The final inventory is

```ini
[appserver]
stapp02 ansible_host=stapp02 ansible_user=steve ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
```

The inventory identifies `stapp02` as the target host and specifies the SSH user and private key.

## Step 5: Validate the Inventory

The inventory can be checked with

```bash
cd /home/thor/ansible
ansible-inventory -i inventory --list
```

The output should contain `stapp02` and the configured SSH connection variables.

## Step 6: Test Ansible Connectivity

Ansible connectivity was tested using

```bash
ansible -i inventory stapp02 -m ping
```

A successful connection returns

```text
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

This confirms that Ansible can connect to App Server 2 using the configured SSH key.

## Step 7: Create the Playbook

The playbook was created at

```text
/home/thor/ansible/playbook.yml
```

The complete playbook is

```yaml
---
- name: Create file on App Server 2
  hosts: appserver

  tasks:
    - name: Create empty file /tmp/file.txt
      ansible.builtin.file:
        path: /tmp/file.txt
        state: touch
```

The `ansible.builtin.file` module is used with `state: touch` to create the required file.

## Step 8: Run the Playbook

From the `/home/thor/ansible` directory

```bash
ansible-playbook -i inventory playbook.yml
```

## Step 9: Verify the File

The file can be verified with

```bash
ssh steve@stapp02 "ls -l /tmp/file.txt"
```

## Troubleshooting SSH

If Ansible reports an authentication failure, first check that the private key exists:

```bash
ls -la /home/thor/.ssh/
```

The following files should exist

```text
id_ed25519
id_ed25519.pub
```

Test SSH directly

```bash
ssh -i /home/thor/.ssh/id_ed25519 steve@stapp02
```

If the connection still requests a password, verify that the public key exists on App Server 2

```bash
ls -la /home/steve/.ssh/
cat /home/steve/.ssh/authorized_keys
```

Verify the permissions

```bash
chmod 700 /home/steve/.ssh
chmod 600 /home/steve/.ssh/authorized_keys
chown -R steve:steve /home/steve/.ssh
```

Once direct SSH works without a password, Ansible should be able to connect using the inventory configuration.

## Main Takeaways

- Ansible inventory defines the hosts managed by a playbook
- `stapp02` identifies App Server 2
- `ansible_user` specifies the remote SSH user
- `ansible_ssh_private_key_file` specifies the private SSH key used by Ansible
- Passwordless SSH allows the required playbook command to run without `--ask-pass` or `--private-key`
- The `ansible.builtin.file` module with `state: touch` can create an empty file
- The final configuration must work with the exact validation command provided by the task

## Conclusion

The Ansible inventory was configured for App Server 2, SSH key-based authentication was established, and the required playbook was created to generate `/tmp/file.txt`. The required resources and configuration were successfully set up and verified.
