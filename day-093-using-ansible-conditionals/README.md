# Ansible Conditional File Deployment

## Objective

The Nautilus DevOps team wants to demonstrate the use of Ansible conditional statements using `when` conditions.

The objective is to create a single Ansible playbook that runs against all application servers and conditionally copies a specific file to each server based on its hostname.

The playbook must be created at:

```text
/home/thor/ansible/playbook.yml
```

The validation will run the playbook using:

```bash
ansible-playbook -i inventory playbook.yml
```

Therefore, the playbook must work without requiring any additional arguments.

## Task Requirements

The following files are available on the Jump Host under

```text
/usr/src/dba/
```

They must be copied to the respective application servers.

| Application Server | Source File | Destination          | Owner    | Group    | Permissions |
| ------------------ | ----------- | -------------------- | -------- | -------- | ----------- |
| App Server 1       | `blog.txt`  | `/opt/dba/blog.txt`  | `tony`   | `tony`   | `0755`      |
| App Server 2       | `story.txt` | `/opt/dba/story.txt` | `steve`  | `steve`  | `0755`      |
| App Server 3       | `media.txt` | `/opt/dba/media.txt` | `banner` | `banner` | `0755`      |

The play must use

```yaml
hosts: all
```

and Ansible `when` conditionals.

## Environment

### Jump Host

```text
User: thor
Ansible Directory: /home/thor/ansible
```

## Step 1: Navigate to the Ansible Directory

On the Jump Host

```bash
cd /home/thor/ansible
```

Check the existing inventory

```bash
cat inventory
```

The inventory should contain all three application servers.

## Step 2: Verify Source Files

The source files are located on the Jump Host

```text
/usr/src/dba/
```

Verify them

```bash
ls -l /usr/src/dba/
```

The directory should contain

```text
blog.txt
story.txt
media.txt
```

## Step 3: Create the Playbook

Create

```text
/home/thor/ansible/playbook.yml
```

Use the following playbook

```yaml
---
- name: Copy DBA files to respective application servers
  hosts: all
  become: true
  gather_facts: true

  tasks:
    - name: Copy blog.txt to App Server 1
      ansible.builtin.copy:
        src: /usr/src/dba/blog.txt
        dest: /opt/dba/blog.txt
        owner: tony
        group: tony
        mode: "0755"
      when: ansible_nodename == "stapp01"

    - name: Copy story.txt to App Server 2
      ansible.builtin.copy:
        src: /usr/src/dba/story.txt
        dest: /opt/dba/story.txt
        owner: steve
        group: steve
        mode: "0755"
      when: ansible_nodename == "stapp02"

    - name: Copy media.txt to App Server 3
      ansible.builtin.copy:
        src: /usr/src/dba/media.txt
        dest: /opt/dba/media.txt
        owner: banner
        group: banner
        mode: "0755"
      when: ansible_nodename == "stapp03"
```

## Step 4: Understand the `when` Conditions

The playbook runs against all servers

```yaml
hosts: all
```

Each server gathers facts before the tasks execute.

The `ansible_nodename` fact identifies the server.

For App Server 1

```yaml
when: ansible_nodename == "stapp01"
```

Therefore only the `blog.txt` task executes on `stapp01`.

For App Server 2

```yaml
when: ansible_nodename == "stapp02"
```

Therefore only the `story.txt` task executes on `stapp02`.

For App Server 3

```yaml
when: ansible_nodename == "stapp03"
```

Therefore only the `media.txt` task executes on `stapp03`.

## Step 5: Run the Playbook

Run the same command used by the validator

```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```

The playbook should execute successfully against all application servers.

The tasks that do not match a server's hostname should show as

```text
skipping
```

This is expected behavior because of the `when` conditions.

## Step 6: Verify the Files

Verify the files on all application servers

```bash
ansible -i inventory all -b -m shell -a "ls -l /opt/dba/"
```

Expected results

### App Server 1

```text
/opt/dba/blog.txt
```

Owned by

```text
tony tony
```

with permissions

```text
0755
```

### App Server 2

```text
/opt/dba/story.txt
```

Owned by

```text
steve steve
```

with permissions

```text
0755
```

### App Server 3

```text
/opt/dba/media.txt
```

Owned by

```text
banner banner
```

with permissions

```text
0755
```

## Step 7: Verify Permissions and Ownership

A convenient verification command is:

```bash
ansible -i inventory all -b -m shell -a "stat -c '%U %G %a %n' /opt/dba/*"
```

The results should show the appropriate user, group, and `755` permissions for each file.

## Validation

The required validation command is

```bash
ansible-playbook -i inventory playbook.yml
```

No additional inventory, variables, or command-line arguments are required.

## Main Takeaways

- Use `hosts: all` when the same play needs to evaluate all managed nodes.
- Use `gather_facts: true` when relying on Ansible gathered facts.
- `ansible_nodename` can be used to identify the current managed server.
- `when` conditions allow individual tasks to execute only on matching servers.
- The Ansible `copy` module can copy files from the controller to managed nodes.
- File ownership and permissions can be configured directly through the `copy` module.
- The playbook can conditionally deploy different files to different servers while using a single play.

## Conclusion

The Ansible playbook was created and configured to conditionally deploy the required files to the respective application servers using Ansible `when` conditions. The required files, ownership, groups, and permissions were configured and verified successfully.
