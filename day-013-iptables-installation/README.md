# Secure Apache Port 5004 Using iptables

## 1. What is the Challenge?

The Apache web server is listening on **port 5004**, but the port is currently accessible from every host because no firewall is configured.

The objective is to improve security by allowing only the **Load Balancer (LBR)** host to access port **5004** while blocking all other incoming connections. The firewall rules must also survive system reboots.

# 2. Required Technology to Solve It

## Linux

Provides system administration and networking tools.

## Apache HTTP Server

Hosts the web application.

## iptables

Linux packet filtering firewall.

## iptables-services

Provides persistent firewall rules across reboots.

# 3. How to Solve It

### Step 1

Install iptables.

```bash
yum install -y iptables iptables-services
```

### Step 2

Determine the Load Balancer IP.

```bash
getent hosts stlb01
```

### Step 3

Allow the LBR host to access Apache.

```bash
iptables -I INPUT -p tcp -s <LBR_IP> --dport 5004 -j ACCEPT
```

### Step 4

Block all other access.

```bash
iptables -A INPUT -p tcp --dport 5004 -j DROP
```

### Step 5

Save the rules.

```bash
iptables-save > /etc/sysconfig/iptables
```

### Step 6

Enable the firewall service.

```bash
systemctl enable iptables
systemctl restart iptables
```

### Step 7

Verify.

```bash
iptables -L -n --line-numbers
```

Expected:

```text
ACCEPT tcp -- <LBR_IP> anywhere tcp dpt:5004
DROP   tcp -- anywhere anywhere tcp dpt:5004
```

# 4. Main Takeaways

- Use **iptables** to restrict access to application ports
- Apply the most specific rule (ALLOW) before the general blocking rule (DROP)
- Save firewall rules so they persist after reboot
- Verify rules after every change
- Principle of Least Privilege: only trusted hosts should access backend services

# 5. Conclusion

This task demonstrates how to secure an Apache service by restricting access to a specific host using **iptables**. Only the Load Balancer is permitted to reach port **5004**, while all other incoming traffic is denied. Saving the firewall configuration ensures the security policy remains active after system reboots.
