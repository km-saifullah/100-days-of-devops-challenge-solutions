# Ansible Inventory Configuration for App Server 3

## Objective

Create an INI-type Ansible inventory file on the Nautilus Jump Host so that the existing Ansible playbook can be executed against App Server 3 in the Stratos Datacenter.

The inventory file must be created at `/home/thor/playbook/inventory`. The target server is App Server 3 and its hostname is `stapp03`.

## What Is the Challenge?

The Nautilus DevOps team already has Ansible playbooks under `/home/thor/playbook/` on the Jump Host. However, Ansible requires an inventory to know which server should be managed and which connection information should be used. The task is to create an INI inventory containing App Server 3.The inventory hostname must match the hostname used in the Stratos Datacenter `stapp03`

The inventory also needs the required SSH username.

## Servers Used

There are two important servers in this task.

### Jump Host

This is the Ansible control node.

```text
Hostname: jump-host
User: thor
```

The inventory and playbook are stored here

```text
/home/thor/playbook/
```

### App Server 3

This is the managed Ansible node.

```text
Hostname: stapp03
User: banner
```

Ansible connects from the Jump Host to App Server 3 over SSH.

## Required Technology

- Ansible
- Ansible INI inventory
- SSH
- Linux

## Step 1 — Go to the Playbook Directory

### Server: Jump Host

Log in as `thor` and run

```bash
cd /home/thor/playbook
```

Check the files

```bash
ls -la
```

The existing playbook should be present

```text
playbook.yml
```

## Step 2 — Check SSH Configuration

### Server: Jump Host

Before creating the inventory, check whether Thor has SSH keys:

```bash
ls -la /home/thor/.ssh/
```

You can also run:

```bash
find /home/thor/.ssh -maxdepth 1 -type f -printf '%f\n'
```

Possible private keys may include:

```text
id_rsa
id_ed25519
```

Do not assume that `id_rsa` exists. If it is not exist then run the following command in the terminal

```text
ssh-keygen
```

## Step-3 - Setup the Public SSH Key in the App Server 3

1. First copy the public key form the **Jump Host**
2. On App Server 3 Create the SSH directory if necessary

```text
sudo mkdir -p /home/banner/.ssh
```

3. Set the ownership

```text
sudo chown banner:banner /home/banner/.ssh
```

4. Set permissions

```text
sudo chmod 700 /home/banner/.ssh
```

5. Then add **Jump Host** public key

```text
sudo vi /home/banner/.ssh/authorized_keys
```

6. Set the Final Permissions

```text
sudo chown banner:banner /home/banner/.ssh/authorized_keys
sudo chmod 600 /home/banner/.ssh/authorized_keys
```

## Step 4 — Create the Inventory

### Server: Jump Host

Go to the playbook directory

```bash
cd /home/thor/playbook
```

Create the inventory

```bash
vi inventory
```

```ini
[appserver]
stapp03 ansible_host=stapp03 ansible_user=banner ansible_ssh_private_key_file=/home/thor/.ssh/id_ed25519
```

Save the file. Ansible supports host-specific variables directly in an INI inventory using `key=value` syntax.

## Step 5 — Verify the Inventory

### Server: Jump Host

Run

```bash
cd /home/thor/playbook
```

Then

```bash
ansible-inventory -i inventory --list
```

```bash
ansible-inventory -i inventory --graph
```

The `ansible-inventory` command displays the inventory as Ansible interprets it.

## Step 6 — Test Ansible Connectivity

### Server: Jump Host

Run

```bash
cd /home/thor/playbook
```

Then

```bash
ansible -i inventory stapp03 -m ping
```

Expected result

```text
stapp03 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Step 7 — Run the Playbook

### Server: Jump Host

Run

```bash
cd /home/thor/playbook
```

Then

```bash
ansible-playbook -i inventory playbook.yml
```

This is the exact command the validation system will use. No additional arguments should be necessary. The required connection information should already be available through the inventory.

## Conclusion

The INI-based Ansible inventory was created on the Jump Host for App Server 3 using the required `stapp03` hostname and SSH user. The incorrect nonexistent private-key reference was identified and removed or replaced with the actual SSH configuration available on the Jump Host. The inventory can be validated with Ansible and the playbook can be executed using the required command without additional arguments.
