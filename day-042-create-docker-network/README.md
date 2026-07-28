# Create a Custom Docker Bridge Network

## 1. What is the Challenge?

The objective is to create a custom Docker network on **Application Server 3**.

The Docker network must:

- Be named **beta**
- Use the **bridge** network driver
- Use the subnet **172.28.0.0/24**
- Use the IP range **172.28.0.0/24**

# 3. How to Solve It

### Step 1

SSH into **Application Server 3**.

```bash
ssh banner@stapp03
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Create the Docker bridge network.

```bash
docker network create \
--driver bridge \
--subnet 172.28.0.0/24 \
--ip-range 172.28.0.0/24 \
beta
```

### Step 3

Verify the network has been created.

```bash
docker network ls
```

Expected output:

```text
NETWORK ID     NAME     DRIVER
xxxxxxxxxxxx   beta     bridge
```

### Step 4

Inspect the network configuration.

```bash
docker network inspect beta
```

Verify the following:

- Driver: **bridge**
- Subnet: **172.28.0.0/24**
- IPRange: **172.28.0.0/24**

# 4. Main Takeaways

- Learned how to create a custom Docker network
- Configured the network to use the **bridge** driver
- Assigned a custom subnet and IP range
- Verified the network using Docker inspection commands

# 5. Conclusion

This task demonstrates how to create a custom Docker bridge network. By defining the network name, driver, subnet, and IP range, containers can communicate within an isolated network that meets the application's networking requirements.
