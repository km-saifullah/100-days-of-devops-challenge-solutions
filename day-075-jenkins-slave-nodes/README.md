# Jenkins SSH Build Agents for Nautilus App Servers

## Objective

Configure the Jenkins server to use all three Nautilus application servers as SSH build agents.

The required nodes are

| App Server   | Jenkins Node Name | Label     | Remote Root Directory  | SSH User |
| ------------ | ----------------- | --------- | ---------------------- | -------- |
| App Server 1 | `App_server_1`    | `stapp01` | `/home/tony/jenkins`   | `tony`   |
| App Server 2 | `App_server_2`    | `stapp02` | `/home/steve/jenkins`  | `steve`  |
| App Server 3 | `App_server_3`    | `stapp03` | `/home/banner/jenkins` | `banner` |

All three nodes must be online and successfully connected to Jenkins.

# Prerequisites

Jenkins SSH agents require a compatible Java runtime.

The Jenkins agent was failing with:

```text
UnsupportedClassVersionError
hudson/remoting/Launcher has been compiled by a more recent version
of the Java Runtime (class file version 61.0)
```

This means the Jenkins agent requires **Java 17**, while the application server was using Java 11.

Therefore, Java 17 must be installed on all three application servers.

# Install Java 17 on App Server 1

Connect from the jump host

```bash
ssh tony@stapp01
```

Install Java 17

```bash
sudo yum install -y java-17-openjdk
```

Verify

```bash
java -version
```

If multiple Java versions are installed, select Java 17

```bash
sudo alternatives --config java
```

Select the Java 17 installation.

Verify again

```bash
java -version
```

The output should show Java 17.

# Install Java 17 on App Server 2

Connect to App Server 2

```bash
ssh steve@stapp02
```

Install Java 17

```bash
sudo yum install -y java-17-openjdk
```

Verify

```bash
java -version
```

If necessary, select Java 17

```bash
sudo alternatives --config java
```

Verify again

```bash
java -version
```

The server should now use Java 17.

# Install Java 17 on App Server 3

Connect to App Server 3

```bash
ssh banner@stapp03
```

Install Java 17:

```bash
sudo yum install -y java-17-openjdk
```

Verify

```bash
java -version
```

If multiple Java versions are installed

```bash
sudo alternatives --config java
```

Select Java 17.

Verify

```bash
java -version
```

The server should now use Java 17.

# Verify Java on All App Servers

From the jump host, Java can be checked remotely

```bash
ssh tony@stapp01 "java -version"
ssh steve@stapp02 "java -version"
ssh banner@stapp03 "java -version"
```

All three servers should report Java 17.

# Access Jenkins

Open the Jenkins UI using the **Jenkins** button in the top bar.

Login with

```text
Username: admin
Password: Adm!n321
```

# Install Required SSH Agent Plugin

Go to

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Search for

```text
SSH Build Agents
```

Install the plugin.

If Jenkins asks for a restart

```text
Restart Jenkins when installation is complete and no jobs are running
```

After the restart, wait for the Jenkins login page to appear and refresh the browser if necessary.

# Add App Server 1

Go to

```text
Manage Jenkins
→ Nodes
→ New Node
```

Create the node with the exact name

```text
App_server_1
```

Select:

```text
Permanent Agent
```

Configure

### Remote root directory

```text
/home/tony/jenkins
```

### Labels

```text
stapp01
```

### Launch method

Select

```text
Launch agents via SSH
```

Configure

```text
Host: stapp01
Port: 22
```

Select/create SSH credentials for

```text
Username: tony
Password: Ir0nM@n
```

For host key verification, use an appropriate Jenkins SSH host-key strategy. In the temporary lab environment, if required, use the non-verifying strategy provided by Jenkins.

Save the configuration.

# 10. Add App Server 2

Create another node

```text
App_server_2
```

Select

```text
Permanent Agent
```

Configure

### Remote root directory

```text
/home/steve/jenkins
```

### Labels

```text
stapp02
```

### Launch method

```text
Launch agents via SSH
```

Configure

```text
Host: stapp02
Port: 22
```

SSH credentials

```text
Username: steve
Password: Am3ric@
```

Save the configuration.

# 11. Add App Server 3

Create another node

```text
App_server_3
```

Select

```text
Permanent Agent
```

Configure

### Remote root directory

```text
/home/banner/jenkins
```

### Labels

```text
stapp03
```

### Launch method

```text
Launch agents via SSH
```

Configure

```text
Host: stapp03
Port: 22
```

SSH credentials

```text
Username: banner
Password: BigGr33n
```

Save the configuration.

# Verify App Server 1

Open

```text
Manage Jenkins
→ Nodes
→ App_server_1
```

Click

```text
Launch agent
```

Jenkins should establish the SSH connection and start the agent.

A successful connection should show messages similar to

```text
[SSH] Opening SSH connection to stapp01:22.
[SSH] Authentication successful.
[SSH] Starting sftp client.
[SSH] Copying latest remoting.jar...
[SSH] Starting agent process
```

The node should become

```text
Online
```

# Verify App Server 2

Open

```text
App_server_2
```

Launch the agent.

Verify that Jenkins successfully connects to

```text
stapp02
```

The node should become

```text
Online
```

# Verify App Server 3

Open

```text
App_server_3
```

Launch the agent.

Verify that Jenkins successfully connects to

```text
stapp03
```

The node should become

```text
Online
```

# Troubleshooting Java Version

If an agent fails with

```text
UnsupportedClassVersionError
```

check Java on the affected server

```bash
java -version
```

If Java 11 or another older version is being used, install Java 17

```bash
sudo yum install -y java-17-openjdk
```

Then select Java 17 if necessary

```bash
sudo alternatives --config java
```

Verify

```bash
java -version
```

After Java 17 is active, relaunch the Jenkins agent.

# Troubleshooting SSH Authentication

If Jenkins reports

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)
```

verify that the SSH credentials configured in Jenkins match the application server.

For example, App Server 1 should use

```text
Host: stapp01
User: tony
```

App Server 2

```text
Host: stapp02
User: steve
```

App Server 3

```text
Host: stapp03
User: banner
```

Test the credentials manually from the jump host

```bash
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```

# Verify All Nodes

Go to

```text
Manage Jenkins
→ Nodes
```

The final configuration should show

```text
App_server_1    stapp01    Online
App_server_2    stapp02    Online
App_server_3    stapp03    Online
```

Verify the labels

```text
App_server_1 → stapp01
App_server_2 → stapp02
App_server_3 → stapp03
```

Verify the remote directories

```text
App_server_1 → /home/tony/jenkins
App_server_2 → /home/steve/jenkins
App_server_3 → /home/banner/jenkins
```

# Final Verification

- Jenkins SSH Build Agents plugin installed
- Java 17 installed on App Server 1
- Java 17 installed on App Server 2
- Java 17 installed on App Server 3
- `App_server_1` created with label `stapp01`
- `App_server_2` created with label `stapp02`
- `App_server_3` created with label `stapp03`
- Correct SSH users configured
- Correct remote root directories configured
- All three Jenkins agents successfully connected
- All three nodes are online and ready to execute Jenkins jobs

# Conclusion

The Jenkins SSH build agents were configured for all three Nautilus application servers. The required Java runtime was installed and verified, and the application servers were successfully connected to Jenkins and confirmed online.
