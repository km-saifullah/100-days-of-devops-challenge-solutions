# Install and Configure Apache Tomcat

## 1. What is the Challenge?

The Nautilus application development team has built a Java web application and wants to deploy it on **App Server 1** using Apache Tomcat.

The requirements are:

- Install Apache Tomcat
- Configure Tomcat to run on **port 5001**
- Deploy the provided `ROOT.war` application
- Ensure the application is accessible directly from the base URL

## 2. Required Technology to Solve It

### Linux Operating System

Basic Linux system administration.

### Apache Tomcat

Apache Tomcat is an open-source Java application server used to deploy Java web applications.

### Java

Tomcat requires a Java Runtime Environment (JRE) to run Java applications.

### SCP (Secure Copy)

Used to transfer the WAR file from the Jump Host to the application server.

### Systemd

Used to manage the Tomcat service.

## 3. How to Solve It

### Step 1: Copy the WAR File

```bash
scp thor@jump-host:/tmp/ROOT.war /tmp/
```

### Step 2: Install Tomcat

```bash
yum install -y tomcat tomcat-webapps tomcat-admin-webapps
```

### Step 3: Change the Listening Port

Edit:

```text
/etc/tomcat/server.xml
```

Replaceline number 71:

```xml
<Connector port="8080"
```

with:

```xml
<Connector port="5001"
```

### Step 4: Deploy the Application

Remove the default ROOT application:

```bash
rm -rf /usr/share/tomcat/webapps/ROOT
rm -f /usr/share/tomcat/webapps/ROOT.war
```

Copy the new application:

```bash
cp /tmp/ROOT.war /usr/share/tomcat/webapps/
```

### Step 5: Restart Tomcat

```bash
systemctl restart tomcat
```

### Step 6: Verify

```bash
curl http://stapp01:5001
```

## 4. Main Takeaways

### Apache Tomcat

Tomcat hosts Java web applications packaged as WAR (Web Application Archive) files.

### ROOT Application

Deploying an application as `ROOT.war` makes it available directly from the server's base URL.

Example:

```text
http://server:port/
```

instead of:

```text
http://server:port/application-name
```

### Tomcat Configuration

The Tomcat listening port is configured in:

```text
/etc/tomcat/server.xml
```

### Service Management

Systemd commands commonly used with Tomcat:

```bash
systemctl start tomcat
systemctl stop tomcat
systemctl restart tomcat
systemctl status tomcat
```

## 5. Conclusion

This task demonstrates how to install Apache Tomcat, customize its listening port, deploy a Java web application, and verify that it is accessible from the base URL. Deploying the application as `ROOT.war` ensures users can access it directly without specifying a context path.
