# Copy a File from Docker Host to a Running Container

## 1. What is the Challenge?

The objective is to copy an encrypted file from the **Docker host** into a running Docker container without modifying the file.

The required tasks are:

- A container named **ubuntu_latest** is already running.
- Copy the file:

```text
/tmp/nautilus.txt.gpg
```

from the Docker host to:

```text
/home/
```

inside the **ubuntu_latest** container.

- Ensure the file remains unchanged during the copy operation.

# 2. Required Technology to Solve It

- Linux
- Docker
- Docker Container
- Docker CLI

# 3. How to Solve It

### Step 1

SSH into **Application Server 1**.

```bash
ssh tony@stapp01
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Verify that the container is running.

```bash
docker ps
```

Expected output should include:

```text
ubuntu_latest
```

### Step 3

Copy the encrypted file from the Docker host into the container.

```bash
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/home/
```

This command copies the file without modifying its contents.

### Step 4

Verify that the file exists inside the container.

```bash
docker exec ubuntu_latest ls -l /home/
```

Expected output:

```text
nautilus.txt.gpg
```

(OR)

You can also verify the exact path.

```bash
docker exec ubuntu_latest ls -l /home/nautilus.txt.gpg
```

# 4. Main Takeaways

- Learned how to copy files between the Docker host and a running container
- Used the `docker cp` command
- Verified the copied file inside the container
- Preserved the original encrypted file without modification

# 5. Conclusion

This task demonstrates how to transfer files from a Docker host into a running container using the `docker cp` command. Since the operation only copies the file, the encrypted file remains unchanged while becoming available inside the container.
