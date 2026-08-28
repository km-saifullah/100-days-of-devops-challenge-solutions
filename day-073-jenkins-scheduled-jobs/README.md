# Jenkins Scheduled Job to Copy Apache Logs

## Objective

Create a Jenkins job named `copy-logs` that periodically collects Apache logs from **App Server 2 (`stapp02`)** and copies both `access_log` and `error_log` to the `/usr/src/security` directory on the **Storage server (`ststor01`)**.

The job must run automatically every 10 minutes and should be tested at least once to verify that the logs are copied successfully.

## Login to Jenkins

Click the **Jenkins** button on the top bar.

Login using

```text
Username: admin
Password: Adm!n321
```

## Create Jenkins Job

From the Jenkins dashboard, click

```text
New Item
```

Enter

```text
copy-logs
```

Select

```text
Freestyle project
```

Click

```text
OK
```

## Configure Periodic Build

In the job configuration, go to

```text
Build Triggers
```

Enable

```text
Build periodically
```

Enter the following cron expression

```text
*/10 * * * *
```

This configures Jenkins to execute the job every 10 minutes.

## Configure SSH Access

The Jenkins job runs using the Jenkins user. SSH key-based authentication should be configured so Jenkins can connect to the required servers without interactive password prompts.

The required server access is

```text
Jenkins → Storage Server
Storage Server → App Server 2
```

The standard server users used in the Stratos Datacenter are

```text
Storage Server:
natasha@ststor01

App Server 2:
steve@stapp02
```

On the Jenkins server, switch to the Jenkins user

```bash
sudo -iu jenkins
```

Verify the user

```bash
whoami
```

Expected output

```text
jenkins
```

If an SSH key does not already exist, generate one

```bash
ssh-keygen -t rsa -b 4096
```

The public key can be displayed using

```bash
cat ~/.ssh/id_rsa.pub
```

Configure the required public key authentication for the Storage server and App Server 2 using the existing server access provided by the lab.

Test access to the Storage server

```bash
ssh -o StrictHostKeyChecking=no natasha@ststor01 "hostname"
```

Expected output

```text
ststor01
```

Test access to App Server 2

```bash
ssh -o StrictHostKeyChecking=no steve@stapp02 "hostname"
```

Expected output

```text
stapp02
```

## Create the Destination Directory

Connect to the Storage server

```bash
ssh -o StrictHostKeyChecking=no natasha@ststor01
```

Create the required directory

```bash
mkdir -p /usr/src/security
```

Verify the directory

```bash
ls -ld /usr/src/security
```

The directory will be used to store the Apache log files collected from App Server 2.

## Verify Apache Logs on App Server 2

Verify that the required Apache log files exist on App Server 2.

Run

```bash
ssh -o StrictHostKeyChecking=no steve@stapp02 \
"ls -lh /var/log/httpd/access_log /var/log/httpd/error_log"
```

The following files should be available

```text
/var/log/httpd/access_log
/var/log/httpd/error_log
```

## Configure Log Collection

Go to

```text
Build Steps → Add build step → Execute shell
```

Add

```bash
#!/bin/bash

ssh -o StrictHostKeyChecking=no natasha@ststor01 \
"scp -o StrictHostKeyChecking=no steve@stapp02:/var/log/httpd/access_log /usr/src/security/ && \
 scp -o StrictHostKeyChecking=no steve@stapp02:/var/log/httpd/error_log /usr/src/security/"
```

## Save the Job

Click

```text
Save
```

The Jenkins job should now be available as

```text
copy-logs
```

The job is configured to execute automatically every 10 minutes.

## Build the Job

Open

```text
copy-logs
```

Click

```text
Build Now
```

This manually triggers the job so that the log collection can be tested immediately without waiting for the scheduled execution.

## Check Build Output

Open the build and select

```text
Console Output
```

Verify that

- Jenkins successfully connects to the Storage server
- The Storage server successfully accesses App Server 2
- `access_log` is copied successfully
- `error_log` is copied successfully
- The build finishes successfully

The build should end with

```text
Finished: SUCCESS
```

## Verify Logs on the Storage Server

Connect to the Storage server

```bash
ssh -o StrictHostKeyChecking=no natasha@ststor01
```

Check the destination directory

```bash
ls -lh /usr/src/security/
```

The following files should be present

```text
access_log
error_log
```

You can also verify the files individually

```bash
ls -lh /usr/src/security/access_log
ls -lh /usr/src/security/error_log
```

The Apache logs from App Server 2 should now be available on the Storage server.

## Test Scheduled Execution

Return to the Jenkins job configuration and verify

```text
Build Triggers
```

The following cron expression should be configured

```text
*/10 * * * *
```

This means Jenkins will automatically execute the job every 10 minutes.

The job can also be manually executed using

```text
Build Now
```

to verify that repeated executions continue to copy the Apache logs successfully.

## Troubleshooting

### SSH Host Key Error

If Jenkins reports an SSH host key verification error, use

```bash
-o StrictHostKeyChecking=no
```

For example

```bash
ssh -o StrictHostKeyChecking=no natasha@ststor01
```

This allows the Jenkins build to connect without an interactive host-key confirmation.

### SSH Permission Error

If SSH authentication fails, verify that the Jenkins user has the required SSH access to the Storage server.

Test from the Jenkins server

```bash
sudo -iu jenkins
ssh -o StrictHostKeyChecking=no natasha@ststor01 "hostname"
```

Also verify access to App Server 2

```bash
ssh -o StrictHostKeyChecking=no steve@stapp02 "hostname"
```

Both commands should complete without an interactive password prompt when passwordless SSH authentication is correctly configured.

### Destination Directory Error

If SCP reports that `/usr/src/security` does not exist, connect to the Storage server and create it

```bash
ssh natasha@ststor01
mkdir -p /usr/src/security
```

Then verify

```bash
ls -ld /usr/src/security
```

### Apache Log File Error

If SCP reports that the source files cannot be found, verify the Apache log files on App Server 2

```bash
ssh steve@stapp02 \
"ls -lh /var/log/httpd/access_log /var/log/httpd/error_log"
```

Make sure both files exist at the default Apache log location.

### SCP Permission Error

If the log files cannot be copied, verify that the user on the Storage server has permission to write to

```text
/usr/src/security
```

Check the directory permissions

```bash
ssh natasha@ststor01 \
"ls -ld /usr/src/security"
```

## Final Verification

- Jenkins job is named `copy-logs`
- The job is a Freestyle project
- The job is configured for periodic execution
- The cron expression is `*/10 * * * *`
- Jenkins can connect to the Storage server
- The Storage server can access App Server 2
- Apache `access_log` is copied from App Server 2
- Apache `error_log` is copied from App Server 2
- Logs are stored in `/usr/src/security`
- The job was manually executed at least once
- The copied log files were verified on the Storage server
- The Jenkins build finishes with `Finished: SUCCESS`

## Conclusion

The `copy-logs` Jenkins job was created and configured to periodically collect Apache logs from App Server 2 and store them on the Storage server. The job was tested successfully, and the required log files were copied and verified in the destination directory.
