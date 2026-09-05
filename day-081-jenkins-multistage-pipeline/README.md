# Jenkins Pipeline Deployment for Static Website

## Objective

The objective of this task is to configure a Jenkins Pipeline job in the Stratos Datacenter to deploy a static website from the Gitea `sarah/web` repository to App Server 1.

The website repository is already cloned on App Server 1 under

```text
/var/www/html
```

The Jenkins Pipeline must run on App Server 1 and contain exactly two stages

```text
Deploy
Test
```

The `Deploy` stage updates the existing Git repository under `/var/www/html` from the `master` branch.

The `Test` stage verifies that the deployed website is accessible through the Load Balancer

```text
http://stlb01:8091
```

The application must be available from the main URL without requiring a `/web` subdirectory.

## Challenge

The development team of xFusionCorp Industries has developed a new static website and wants to deploy it to Nautilus App Server 1 using a Jenkins Pipeline.

The main requirements are

1. Update `index.html` in the Gitea `sarah/web` repository
2. Push the change to the `master` branch
3. Configure App Server 1 as a Jenkins SSH agent
4. Create a Jenkins Pipeline job named `deploy-job`
5. Run the Pipeline on App Server 1
6. Deploy the website under `/var/www/html`
7. Verify the application through the Load Balancer
8. Make sure the Test stage fails when the application is not working or the deployment fails

The final website content must be

```text
Welcome to xFusionCorp Industries
```

The application must be accessible from

```text
http://stlb01:8091
```

## Required Technology

The following technologies are used:

- Jenkins
- Jenkins Pipeline
- Jenkins Git plugin
- Jenkins SSH Build Agents plugin
- Git
- Apache/httpd
- Java 17
- curl

The Jenkins Pipeline plugin is required because the task specifically requires a Pipeline job.

The SSH Build Agents plugin is required because App Server 1 is connected to Jenkins using SSH.

## Environment

| Component            | Details                     |
| -------------------- | --------------------------- |
| Jenkins username     | `admin`                     |
| Jenkins password     | `Adm!n321`                  |
| Gitea username       | `sarah`                     |
| Gitea password       | `Sarah_pass123`             |
| Gitea repository     | `sarah/web`                 |
| Git branch           | `master`                    |
| App Server           | App Server 1                |
| App Server hostname  | `stapp01`                   |
| Jenkins node name    | `App Server 1`              |
| Jenkins node label   | `stapp01`                   |
| Jenkins remote root  | `/home/sarah/jenkins_agent` |
| Jenkins job          | `deploy-job`                |
| Deployment directory | `/var/www/html`             |
| Apache service       | `httpd`                     |
| Apache port          | `8080`                      |
| Load Balancer        | `stlb01`                    |
| Load Balancer port   | `8091`                      |
| Application URL      | `http://stlb01:8091`        |

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

Install the following plugins if they are not already installed

```text
Pipeline
Git
SSH Build Agents
```

# Install Java 17 on App Server 1

Jenkins agents require Java.

Connect to App Server 1

```bash
ssh sarah@stapp01
```

Check the installed Java version

```bash
java -version
```

If Java 17 is not installed, install it

```bash
sudo dnf install -y java-17-openjdk
```

Verify

```bash
java -version
```

The output should indicate Java 17.

# Configure App Server 1 Jenkins Agent

The Pipeline must run on App Server 1 because the existing website repository is located under:

```text
/var/www/html
```

Go to

```text
Manage Jenkins
→ Nodes
→ New Node
```

Create the node with

```text
Node name: App Server 1
```

Select

```text
Permanent Agent
```

Configure

```text
Remote root directory:
/home/sarah/jenkins_agent
```

Set the label to

```text
stapp01
```

For the launch method select

```text
Launch agents via SSH
```

Set the host to

```text
stapp01
```

Configure SSH credentials for the `sarah` user.

The important values are

```text
Name: App Server 1
Label: stapp01
Remote root directory: /home/sarah/jenkins_agent
Host: stapp01
User: sarah
Launch method: SSH
```

After saving the node configuration, Jenkins should connect to App Server 1 successfully.

The node should show

```text
Online
```

# Verify SSH Access

Verify that App Server 1 can be reached

```bash
ssh sarah@stapp01
```

After connecting

```bash
hostname
```

Verify Java

```bash
java -version
```

# Verify Apache

Apache is already installed on App Server 1 and is expected to run on port `8080`.

Check the service

```bash
sudo systemctl status httpd
```

Check port 8080

```bash
sudo ss -lntp | grep :8080
```

Test Apache locally

```bash
curl http://localhost:8080
```

Apache should return the website content.

If Apache is not running

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

# Verify the Existing Git Repository

The task provides the `sarah/web` repository already cloned under

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

Check the branch

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

The remote branch should be

```text
origin/master
```

# Update index.html

Go to

```bash
cd /var/www/html
```

Edit:

```bash
vi index.html
```

Set the content to

```text
Welcome to xFusionCorp Industries
```

Verify

```bash
cat index.html
```

# Commit and Push the Website Change

Check Git status

```bash
git status
```

Add the file

```bash
git add index.html
```

Commit

```bash
git commit -m "Update index.html"
```

Push to the master branch

```bash
git push origin master
```

Verify the remote branch

```bash
git fetch origin
git log origin/master -1 --oneline
```

The updated `index.html` must be present on `origin/master`.

# Verify Gitea Repository

Open the Gitea UI and navigate to

```text
sarah
→ web
→ master
→ index.html
```

Verify that it contains

```text
Welcome to xFusionCorp Industries
```

The change must be committed and pushed to the remote `master` branch before the Jenkins deployment.

# Create Jenkins Pipeline Job

Go to

```text
Jenkins Dashboard
→ New Item
```

Enter

```text
deploy-job
```

Select

```text
Pipeline
```

Click

```text
OK
```

The job must be a normal Jenkins Pipeline job.

# Configure deploy-job

Open

```text
deploy-job
→ Configure
```

Under the Pipeline section, use

```text
Definition
Pipeline script
```

Save the configuration.

# Jenkins Pipeline

The Pipeline contains exactly two required stages

```text
Deploy
Test
```

The stage names are case-sensitive.

Use the following Jenkinsfile

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

                    cd /var/www/html

                    echo "Pulling latest changes..."
                    git pull origin master

                    echo "Current deployed commit:"
                    git log -1 --oneline

                    echo "Current index.html:"
                    cat index.html
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    set -e

                    echo "Testing application through Load Balancer..."

                    WEB_CONTENT=$(curl -fsS http://stlb01:8091)
                    FILE_CONTENT=$(cat /var/www/html/index.html)

                    echo "Website content:"
                    echo "$WEB_CONTENT"

                    echo "Local index.html:"
                    echo "$FILE_CONTENT"

                    if [ "$WEB_CONTENT" = "$FILE_CONTENT" ]; then
                        echo "Website content matches deployed index.html"
                    else
                        echo "Website content does not match deployed index.html"
                        exit 1
                    fi
                '''
            }
        }
    }
}
```

# Deploy Stage

The `Deploy` stage runs on App Server 1 because the Pipeline uses

```groovy
agent {
    label 'stapp01'
}
```

The stage changes to

```text
/var/www/html
```

and pulls the latest code

```bash
git pull origin master
```

The repository is already cloned on App Server 1, so Jenkins does not need to create another copy of the website.

The command

```bash
set -e
```

causes the stage to stop immediately if a command fails.

The stage also displays the deployed commit

```bash
git log -1 --oneline
```

and verifies the deployed file

```bash
cat index.html
```

# Test Stage

The `Test` stage verifies the application through the Load Balancer

```text
http://stlb01:8091
```

The website response is retrieved using

```bash
curl -fsS http://stlb01:8091
```

The deployed local file is read using

```bash
cat /var/www/html/index.html
```

The Pipeline compares the Load Balancer response with the deployed file. If they match, the Test stage succeeds. If the Load Balancer cannot be reached, curl fails and the stage fails. If the website returns different content, the comparison fails and the stage exits with status `1`. Therefore, the Test stage fails when the application is not working correctly.

# Run the Pipeline

Go to

```text
Jenkins Dashboard
→ deploy-job
→ Build Now
```

Open

```text
Console Output
```

The final result should be

```text
Finished: SUCCESS
```

# Verify the Deployment Manually

Connect to App Server 1

```bash
ssh sarah@stapp01
```

Go to the repository

```bash
cd /var/www/html
```

Check the branch

```bash
git branch
```

Expected

```text
* master
```

Check the latest commit

```bash
git log -1 --oneline
```

Check the deployed content

```bash
cat index.html
```

Expected

```text
Welcome to xFusionCorp Industries
```

# Verify Load Balancer

Test the application through the Load Balancer

```bash
curl http://stlb01:8091
```

Expected Response

```text
Welcome to xFusionCorp Industries
```

# Troubleshooting

## Jenkins Agent Is Offline

Go to

```text
Manage Jenkins
→ Nodes
→ App Server 1
```

Check the agent log.

Verify Java

```bash
java -version
```

Install Java 17 if necessary

```bash
sudo dnf install -y java-17-openjdk
```

Verify the remote root

```bash
ls -ld /home/sarah/jenkins_agent
```

Verify SSH

```bash
ssh sarah@stapp01
```

Also verify that the SSH Build Agents plugin is installed.

## Java Installation Problem

Check

```bash
java -version
```

Install Java 17

```bash
sudo dnf install -y java-17-openjdk
```

Verify

```bash
java -version
```

# Conclusion

The Jenkins Pipeline deployment workflow was successfully configured for the static website. The required Jenkins agent, Pipeline job, deployment configuration, and application validation were set up and verified successfully.
