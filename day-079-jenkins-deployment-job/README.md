# Jenkins Automated Deployment from Gitea

## Objective

The objective of this task is to configure Jenkins to automatically deploy a static website whenever a developer pushes a new change to the `master` branch of a Gitea repository.

The repository is hosted in Gitea under the `sarah` user and is already cloned on App Server 1 at

```text
/home/sarah/web
```

Whenever a developer pushes a new change to the `master` branch, Gitea sends a webhook request to Jenkins.

Jenkins then runs the deployment pipeline and deploys the complete repository content to

```text
/var/www/html
```

on App Server 1.

The website must be accessible from the main application URL without any repository subdirectory.

## Environment

| Component           | Details               |
| ------------------- | --------------------- |
| Git Server          | Gitea                 |
| Git User            | sarah                 |
| Git Repository      | web                   |
| Git Branch          | master                |
| Jenkins Job         | devops-app-deployment |
| Jenkins Agent       | App Server 1          |
| Jenkins Agent Label | stapp01               |
| Repository Location | /home/sarah/web       |
| Deployment Location | /var/www/html         |
| Web Server          | Apache/httpd          |
| Apache Port         | 8080                  |
| Application URL     | http://stlb01:8091    |

## Deployment Architecture

```text
Developer
    |
    | git push origin master
    v
Gitea Repository
    |
    | Webhook
    v
Jenkins
    |
    | devops-app-deployment
    v
App Server 1
    |
    | /home/sarah/web
    |
    | git fetch + reset
    |
    | rsync
    v
/var/www/html
    |
    v
Apache :8080
    |
    v
Load Balancer
    |
    v
http://stlb01:8091
```

## Required Jenkins Plugins

The following plugins are required

```text
Pipeline
Git
SSH Build Agents
Generic Webhook Trigger
```

### Pipeline Plugin

The Pipeline plugin is required to create a Jenkins Pipeline job.

Without this plugin, the `Pipeline` option may not appear while creating a new Jenkins job.

### Git Plugin

The Git plugin provides Git integration for Jenkins.

### SSH Build Agents Plugin

The SSH Build Agents plugin is required to connect Jenkins to App Server 1 through SSH.

It provides the

```text
Launch agents via SSH
```

option.

### Generic Webhook Trigger Plugin

The Generic Webhook Trigger plugin allows Jenkins to receive HTTP webhook requests from Gitea and trigger the Jenkins job automatically.

## Installing Jenkins Plugins

Open Jenkins from the top bar.

Go to

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Search for and install

```text
Pipeline
Git
SSH Build Agents
Generic Webhook Trigger
```

After installation, restart Jenkins when no jobs are running.

If the Jenkins UI becomes stuck after the restart, refresh the browser.

## Configure App Server 1

SSH into App Server 1

```bash
ssh sarah@stapp01
```

Verify the operating system

```bash
cat /etc/os-release
```

## Configure Apache

Apache/httpd was already installed and configured to listen on port `8080`.

Make sure the service is running

```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```

Check the service

```bash
sudo systemctl status httpd
```

Verify port `8080`

```bash
sudo ss -lntp | grep 8080
```

Test Apache locally

```bash
curl http://localhost:8080
```

## Prepare the Deployment Directory

Create the deployment directory if necessary

```bash
sudo mkdir -p /var/www/html
```

Set ownership to `sarah`

```bash
sudo chown -R sarah:sarah /var/www/html
```

Verify

```bash
ls -ld /var/www/html
```

The owner should be

```text
sarah
```

## Verify the Existing Git Repository

The repository is already cloned on App Server 1.

Go to

```bash
cd /home/sarah/web
```

Check the repository

```bash
git status
```

Check the branch

```bash
git branch
```

Check the remote

```bash
git remote -v
```

## Update index.html

Update the website content

```bash
cd /home/sarah/web

cat > index.html <<'EOF'
Welcome to the xFusionCorp Industries
EOF
```

Verify

```bash
cat index.html
```

Expected output

```text
Welcome to the xFusionCorp Industries
```

## Commit and Push the Change

Add the change

```bash
git add index.html
```

Commit

```bash
git commit -m "Update welcome page"
```

Push to the master branch

```bash
git push origin master
```

This push is also used to test the Jenkins webhook.

## Configure Jenkins Agent

Create a Jenkins node

```text
Name
App Server 1
```

Select

```text
Permanent Agent
```

Configure

```text
Number of executors:
1

Remote root directory:
/home/sarah/jenkins_agent

Labels
stapp01
```

Select

```text
Launch agents via SSH
```

Configure

```text
Host
stapp01

Username
sarah
```

Use the appropriate SSH credentials for `sarah`.

The node should become

```text
Online
```

before testing the Pipeline.

## Create Jenkins Job

Go to

```text
Jenkins
→ New Item
```

Enter

```text
devops-app-deployment
```

Select

```text
Pipeline
```

Do not select

```text
Multibranch Pipeline
```

Click `OK`.

## Configure Jenkins Webhook Trigger

Open

```text
devops-app-deployment
→ Configure
```

Scroll to

```text
Build Triggers
```

Enable

```text
Generic Webhook Trigger
```

Set the token to

```text
devops-app-deployment
```

Save the job configuration.

## Jenkins Generic Webhook URL

The Jenkins server URL used in the lab was

```text
https://8080-port-4tsq4mzrcqk2r4ok.labs.kodekloud.com
```

Therefore, the Generic Webhook Trigger endpoint is

```text
https://8080-port-4tsq4mzrcqk2r4ok.labs.kodekloud.com/generic-webhook-trigger/invoke?token=devops-app-deployment
```

This URL is used in the Gitea webhook configuration.

The Jenkins token and the token in the Gitea URL must match

```text
devops-app-deployment
```

## Configure Gitea Webhook

Open Gitea from the top bar.

Login using

```text
Username
sarah

Password
Sarah_pass123
```

Open the repository

```text
web
```

Navigate to

```text
Repository
→ Settings
→ Webhooks
→ Add Webhook
```

Select

```text
Gitea
```

For the target URL use

```text
https://8080-port-4tsq4mzrcqk2r4ok.labs.kodekloud.com/generic-webhook-trigger/invoke?token=devops-app-deployment
```

Enable

```text
Push Events
```

Make sure the webhook is

```text
Active
```

Save the webhook.

## Webhook Flow

The important configuration is

```text
Gitea
   |
   | Push event
   v
https://8080-port-4tsq4mzrcqk2r4ok.labs.kodekloud.com/generic-webhook-trigger/invoke?token=devops-app-deployment
   |
   v
Jenkins
   |
   | token = devops-app-deployment
   v
devops-app-deployment
```

The Jenkins token and the token in the Gitea webhook URL must be identical.

## Test the Webhook

Make a new change in the repository

```bash
cd /home/sarah/web
```

For example

```bash
echo "<!-- Jenkins webhook test -->" >> index.html
```

Commit the change

```bash
git add index.html
git commit -m "Test Jenkins webhook"
```

Push to master

```bash
git push origin master
```

Jenkins should automatically start a new build.

The Jenkins build log should show a webhook-triggered cause such as

```text
Started by Generic Cause
```

This confirms that the Gitea webhook successfully triggered Jenkins.

## Jenkins Pipeline

Use the following Pipeline

```groovy
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Deploy') {
            steps {
                sh '''
                    set -e

                    echo "Starting deployment..."

                    cd /home/sarah/web

                    echo "Fetching latest changes from origin..."
                    git fetch origin

                    echo "Switching to master branch..."
                    git checkout master

                    echo "Resetting local repository to origin/master..."
                    git reset --hard origin/master

                    echo "Preparing deployment directory..."
                    sudo -n chown -R sarah:sarah /var/www/html

                    echo "Deploying complete repository..."
                    sudo -n rsync -a --delete \
                        --exclude='.git' \
                        /home/sarah/web/ \
                        /var/www/html/

                    echo "Setting ownership..."
                    sudo -n chown -R sarah:sarah /var/www/html

                    echo "Ensuring httpd is running..."
                    sudo -n systemctl start httpd

                    echo "Deployment completed successfully."

                    echo "Deployed files:"
                    ls -la /var/www/html
                '''
            }
        }
    }
}
```

## Why git fetch and git reset Are Used

The repository is already cloned on App Server 1.

Therefore, Jenkins does not need to clone the repository every time.

The Pipeline uses

```bash
git fetch origin
```

to retrieve the latest changes.

Then

```bash
git checkout master
```

ensures that the deployment uses the master branch.

Finally

```bash
git reset --hard origin/master
```

makes the local repository exactly match the latest `origin/master`.

## Why rsync Is Used

The requirement is to deploy the entire repository rather than only `index.html`.

The Pipeline uses

```bash
sudo -n rsync -a --delete \
    --exclude='.git' \
    /home/sarah/web/ \
    /var/www/html/
```

This copies the complete repository content to

```text
/var/www/html
```

The `.git` directory is excluded because Git metadata should not be exposed by Apache.

The `--delete` option ensures that files removed from the repository are also removed from the deployment directory.

This makes `/var/www/html` match the repository content.

# Troubleshooting and Issues Encountered

## Issue 1 — Pipeline Option Was Missing

### Problem

While creating the Jenkins job, the `Pipeline` option was not available.

Only options such as

```text
Freestyle project
```

were visible.

### Cause

The Jenkins Pipeline plugin had not been installed.

### Solution

Go to

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Install

```text
Pipeline
```

Restart Jenkins.

After restarting, the `Pipeline` job type becomes available.

## Issue 2 — SSH Launch Method Was Missing

### Problem

The Jenkins node configuration did not provide:

```text
Launch agents via SSH
```

### Cause

The SSH Build Agents plugin was not installed.

### Solution

Install

```text
SSH Build Agents
```

from

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Restart Jenkins.

After installation, the SSH launch method becomes available.

## Issue 3 — Jenkins Sudo Password Error

### Problem

The first Jenkins build failed with

```text
sudo: a terminal is required to read the password; either use ssh's -t option or configure an askpass helper
sudo: a password is required
```

The failing command was

```bash
sudo chown -R sarah:sarah /var/www/html
```

### Cause

Jenkins was running the Pipeline as the `sarah` user. The `sudo` command required a password. Jenkins cannot interactively enter a sudo password during a Pipeline shell step.

### Solution

Configure passwordless sudo for the required deployment commands.

On App Server 1

```bash
sudo visudo -f /etc/sudoers.d/jenkins-sarah
```

Add

```text
sarah ALL=(ALL) NOPASSWD: /usr/bin/chown, /usr/bin/systemctl, /usr/bin/rsync
```

Save the file.

Verify

```bash
sudo -l -U sarah
```

Test

```bash
sudo -n chown -R sarah:sarah /var/www/html
```

Test Apache

```bash
sudo -n systemctl start httpd
```

Test rsync

```bash
sudo -n rsync --version
```

All required commands should work without asking for a password.

## Issue 4 — rsync Command Not Found

### Problem

After fixing the sudo issue, the Jenkins build failed with

```text
rsync: command not found
```

The Jenkins log showed

```text
line 21: rsync: command not found
```

### Cause

`rsync` was not installed on App Server 1.

### Solution

SSH into App Server 1

```bash
ssh sarah@stapp01
```

Install rsync.

For systems using `dnf`

```bash
sudo dnf install -y rsync
```

If `dnf` is unavailable

```bash
sudo yum install -y rsync
```

Verify

```bash
rsync --version
```

## 28. Test the Jenkins Pipeline

After installing `rsync` and configuring passwordless sudo, run the Jenkins job.

Go to

```text
Jenkins
→ devops-app-deployment
→ Build Now
```

## Test Automatic Deployment

Make another change

```bash
cd /home/sarah/web
```

For example

```bash
echo "<!-- automatic deployment test -->" >> index.html
```

Commit

```bash
git add index.html
git commit -m "Test automatic deployment"
```

Push:

```bash
git push origin master
```

The Gitea webhook should automatically trigger

```text
devops-app-deployment
```

No manual Jenkins build should be required.

## Verify Deployment

On App Server 1

```bash
ls -la /var/www/html
```

Verify the main page

```bash
cat /var/www/html/index.html
```

Expected

```text
Welcome to the xFusionCorp Industries
```

Verify Apache

```bash
sudo systemctl status httpd
```

Verify port

```bash
sudo ss -lntp | grep 8080
```

## Verify the Application

Test the application through the load balancer

```bash
curl http://stlb01:8091
```

The website should be accessible from

```text
http://stlb01:8091
```

It should not require

```text
http://stlb01:8091/web
```

The repository directory name `web` must not become part of the public URL.

## Main Takeaways

This task demonstrates a complete Git-based CI/CD deployment workflow using Gitea and Jenkins.

A developer pushes changes to the `master` branch of the Gitea repository. Gitea sends a webhook to Jenkins, which automatically starts the `devops-app-deployment` Pipeline. The Jenkins agent runs on App Server 1 as the `sarah` user. The Pipeline updates the existing Git repository and synchronizes the complete repository content to `/var/www/html`. Correct ownership and passwordless sudo permissions are important because Jenkins needs to perform deployment-related operations without interactive password input. The deployment also requires `rsync` to synchronize the complete repository content.

After resolving the missing Pipeline plugin, SSH Build Agents plugin, sudo password issue, and missing rsync package, the webhook-triggered deployment works correctly.

## Conclusion

The Jenkins automated deployment pipeline was successfully configured. The required Jenkins plugins, Jenkins agent, Gitea webhook, Git repository deployment, Apache configuration, permissions, and automatic deployment process were successfully set up and verified.
