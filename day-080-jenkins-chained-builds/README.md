# Jenkins Chained Builds for Apache Service Management

## Objective

The objective of this task is to configure Jenkins chained builds in the Stratos Datacenter.

Two Jenkins jobs are required.

The first job, `xfusion-app-deployment`, is responsible for pulling the latest changes from the `master` branch of the Gitea `web` repository and updating the application deployed under `/var/www/html` on App Server 1.

The second job, `manage-services`, is configured as a downstream job of `xfusion-app-deployment`. It restarts the Apache/httpd service on App Server 1 only when the deployment job completes successfully and is stable.

The application must be available from the main load-balancer URL

```text
http://stlb01:8091
```

The application must not require a `/web` subdirectory.

## Challenge

The DevOps team wants Apache to be restarted only after the application deployment has completed successfully.

Instead of putting deployment and service management into one job, Jenkins chained builds are used.

The first job performs the deployment

```text
xfusion-app-deployment
```

The second job manages the Apache service

```text
manage-services
```

The second job must only execute when the deployment job is stable.

## Required Technology

The following technologies are used:

- Jenkins
- Jenkins Git plugin
- Jenkins SSH Build Agents plugin
- Gitea
- Git
- Apache/httpd
- Linux
- SSH
- sudo
- Jenkins Freestyle jobs

The SSH Build Agents plugin provides SSH-based Jenkins agent launching.

## Environment

| Component            | Details              |
| -------------------- | -------------------- |
| Jenkins username     | `admin`              |
| Jenkins password     | `Adm!n321`           |
| Gitea username       | `sarah`              |
| Gitea password       | `Sarah_pass123`      |
| Gitea repository     | `web`                |
| Git branch           | `master`             |
| App Server           | App Server 1         |
| App Server hostname  | `stapp01`            |
| Deployment directory | `/var/www/html`      |
| Apache service       | `httpd`              |
| Load Balancer        | `stlb01`             |
| Application URL      | `http://stlb01:8091` |

# Install Required Jenkins Plugins

Login to Jenkins using

```text
Username: admin
Password: Adm!n321
```

Navigate to

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Install

```text
Git
```

and

```text
SSH Build Agents
```

The SSH Build Agents plugin is required when Jenkins agents are launched using SSH.

Pipeline is not required for this particular implementation because the task can be completed using Jenkins Freestyle jobs.

After installing plugins, restart Jenkins when no plugin installation or update jobs are running.

If the Jenkins interface becomes stuck after the restart, refresh the browser.

# Configure App Server 1 Jenkins Agent

The deployment job must run on App Server 1 because `/var/www/html` is the local Git repository on that server.

Go to

```text
Manage Jenkins
→ Nodes
```

Verify that App Server 1 is online.

A typical configuration is

```text
Node name: App_server_1
Label: stapp01
Remote root directory: /home/tony/jenkins
Launch method: Launch agents via SSH
```

Verify the node status is

```text
Online
```

# Verify Java

On App Server 1

```bash
java -version
```

If Java is not installed

```bash
sudo dnf install -y java-21-openjdk
```

Verify again

```bash
java -version
```

# Verify the Existing Git Repository

The task provides a local Git repository under

```text
/var/www/html
```

On App Server 1

```bash
cd /var/www/html
```

Check the repository

```bash
git status
```

Check the remote

```bash
git remote -v
```

Check the current branch

```bash
git branch
```

Check remote branches

```bash
git branch -r
```

The required branch is

```text
master
```

and the remote branch should be:

```text
origin/master
```

# Configure sudo

Jenkins must be able to execute deployment-related commands using sudo.

For an App Server 1 Jenkins agent running as `tony`, create:

```bash
sudo vi /etc/sudoers.d/jenkins-deployment
```

Add

```text
sarah ALL=(ALL) NOPASSWD: /usr/bin/git, /usr/bin/chown, /usr/bin/systemctl
```

Validate the configuration

```bash
sudo visudo -cf /etc/sudoers.d/jenkins-deployment
```

Test

```bash
sudo -n git --version
```

Test Apache access

```bash
sudo -n systemctl status httpd
```

The `sudo -n` option prevents Jenkins from waiting for an interactive password.

# Create xfusion-app-deployment

Go to

```text
Jenkins Dashboard
→ New Item
```

Enter

```text
xfusion-app-deployment
```

Select

```text
Freestyle project
```

Click

```text
OK
```

# Configure xfusion-app-deployment

Under

```text
General
```

enable

```text
Restrict where this project can be run
```

Enter

```text
stapp01
```

This ensures that the deployment executes on App Server 1.

# Source Code Management

The `/var/www/html` directory is already a local Git repository.

Therefore, the deployment job does not need to create a separate Jenkins workspace copy of the website.

The Git repository will be updated directly from:

```text
/var/www/html
```

The Git operations will be performed from the Jenkins build step.

# Configure Deployment Build Step

Go to

```text
Build Steps
→ Add build step
→ Execute shell
```

Use

```bash
#!/bin/bash

set -e

echo "========================================"
echo "Starting application deployment"
echo "========================================"

cd /var/www/html

echo "Fetching latest changes from origin..."
sudo -n git fetch origin

echo "Checking out master branch..."
sudo -n git checkout master

echo "Synchronizing local repository with origin/master..."
sudo -n git reset --hard origin/master

echo "Setting website ownership..."
sudo -n chown -R sarah:sarah /var/www/html

echo "Deployment completed successfully."

echo "Current deployed commit:"
sudo -n git log -1 --oneline

echo "Deployed files:"
ls -la /var/www/html

echo "========================================"
echo "Deployment finished successfully"
echo "========================================"
```

Click

```text
Save
```

# Test xfusion-app-deployment

Click

```text
Build Now
```

Open

```text
Console Output
```

The build should finish successfully

```text
Finished: SUCCESS
```

The deployment directory should now contain the latest version from

```text
origin/master
```

# Why git fetch and git reset are used

The deployment uses

```bash
sudo -n git fetch origin
```

to retrieve the latest information from the remote repository.

Then

```bash
sudo -n git checkout master
```

ensures that the required branch is selected.

Finally

```bash
sudo -n git reset --hard origin/master
```

makes the local deployment directory match the latest remote master branch.

This is useful because the Jenkins validation system may run the deployment job multiple times.

The deployment therefore remains repeatable.

# Create manage-services

Create another Jenkins job

```text
New Item
→ manage-services
→ Freestyle project
```

Click

```text
OK
```

# Configure manage-services Node

Under

```text
General
```

enable

```text
Restrict where this project can be run
```

Enter

```text
stapp01
```

This makes the service-management job run on App Server 1.

# Configure Downstream Build

Go to

```text
Build Triggers
```

Enable

```text
Build after other projects are built
```

Under

```text
Projects to watch
```

enter

```text
xfusion-app-deployment
```

Select

```text
Stable
```

or

```text
Trigger only if build is stable
```

If the deployment job fails or becomes unstable, the service-management job should not be triggered.

# Configure Apache Restart

In `manage-services`, go to

```text
Build Steps
→ Add build step
→ Execute shell
```

Use

```bash
#!/bin/bash

set -e

echo "========================================"
echo "Restarting Apache/httpd"
echo "========================================"

sudo -n systemctl restart httpd

echo "Checking Apache/httpd status..."

sudo -n systemctl is-active --quiet httpd

echo "Apache/httpd is running successfully."

echo "========================================"
echo "Service management completed"
echo "========================================"
```

Click

```text
Save
```

# Test Jenkins Chained Builds

Do not manually run the downstream job for the main test.

Run

```text
xfusion-app-deployment
→ Build Now
```

Open the `manage-services` build and check the console output.

It should show

```text
Restarting Apache/httpd
```

and

```text
Apache/httpd is running successfully.
```

The final result should be

```text
Finished: SUCCESS
```

# Verify Apache

On App Server 1

```bash
sudo systemctl status httpd
```

Or

```bash
sudo systemctl is-active httpd
```

# Verify Website Files

Check

```bash
ls -la /var/www/html
```

Check ownership

```bash
ls -ld /var/www/html
```

The directory should belong to

```text
sarah:sarah
```

Check Git

```bash
cd /var/www/html
git status
```

Check the latest commit

```bash
git log -1 --oneline
```

# Troubleshooting

## Jenkins agent is offline

Go to

```text
Manage Jenkins
→ Nodes
→ App_server_1
```

Check the agent log.

Verify

```bash
java -version
```

Also verify that the SSH Build Agents plugin is installed.

## SSH Build Agents option is missing

Go to

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Search

```text
SSH Build Agents
```

Install it and restart Jenkins.

## sudo asks for a password

Verify

```bash
sudo visudo -cf /etc/sudoers.d/jenkins-deployment
```

Then test

```bash
sudo -n git --version
sudo -n systemctl status httpd
```

Make sure the sudoers file contains

```text
sarah ALL=(ALL) NOPASSWD: /usr/bin/git, /usr/bin/chown, /usr/bin/systemctl
```

## Deployment job fails with Git errors

Run

```bash
cd /var/www/html
git status
git remote -v
git branch
git branch -r
```

Then test

```bash
sudo -n git fetch origin
```

and

```bash
sudo -n git reset --hard origin/master
```

## Apache restart fails

Check

```bash
sudo systemctl status httpd
```

Check the configuration

```bash
sudo apachectl configtest
```

Then

```bash
sudo systemctl restart httpd
```

If it works manually but fails in Jenkins, verify the sudoers configuration.

# Final Validation Checklist

Before completing the task, verify

- [ ] Git plugin is installed
- [ ] SSH Build Agents plugin is installed
- [ ] App Server 1 Jenkins agent is online
- [ ] `xfusion-app-deployment` exists
- [ ] `xfusion-app-deployment` runs on App Server 1
- [ ] `/var/www/html` is used as the deployment directory
- [ ] The repository uses the `master` branch
- [ ] `origin/master` is updated before deployment
- [ ] `/var/www/html` is synchronized with `origin/master`
- [ ] `/var/www/html` ownership is `sarah:sarah`
- [ ] `manage-services` exists
- [ ] `manage-services` is configured as a downstream job
- [ ] `xfusion-app-deployment` is the upstream project
- [ ] Downstream execution happens only when the upstream build is stable
- [ ] `manage-services` restarts `httpd`
- [ ] Apache/httpd is active after restart
- [ ] Repeated runs of the deployment job succeed
- [ ] Repeated runs do not corrupt the deployment
- [ ] The application loads from `http://stlb01:8091`
- [ ] `/web` is not required in the URL

# Conclusion

The Jenkins chained-build workflow was configured with a deployment job and a downstream service-management job. The deployment job updates the application from the master branch, while the downstream job restarts Apache only after a stable deployment. The required resources and configuration were successfully set up and verified.
