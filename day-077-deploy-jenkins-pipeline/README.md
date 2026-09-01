# Jenkins Pipeline Deployment to Nautilus App Server

## Objective

Create a Jenkins pipeline to deploy the `web_app` static website to Nautilus App Server 1.

The application repository is already cloned on App Server 1 under `/var/www/html`, which is the Apache document root.

The Jenkins pipeline must

- Use App Server 1 as a Jenkins SSH build agent
- Use label `stapp01`
- Use `/home/sarah/jenkins_agent` as the Jenkins agent remote root directory
- Create a pipeline job named `nautilus-webapp-job`
- Use a regular Pipeline job, not a Multibranch Pipeline
- Contain exactly one stage named `Deploy`
- Deploy the latest repository changes directly into `/var/www/html`
- Make the application available from the main Load Balancer URL

## Infrastructure Details

| Component               | Details                     |
| ----------------------- | --------------------------- |
| Jenkins Server          | `jenkins`                   |
| Jenkins Admin           | `admin`                     |
| App Server              | `stapp01`                   |
| App Server User         | `sarah`                     |
| Repository              | `web_app`                   |
| Repository Location     | `/var/www/html`             |
| Jenkins Agent Directory | `/home/sarah/jenkins_agent` |
| Jenkins Agent Label     | `stapp01`                   |
| Apache Port             | `8080`                      |
| Jenkins Job             | `nautilus-webapp-job`       |

## Prerequisites

The following are already available

- Jenkins server
- Gitea server
- `web_app` repository
- Repository cloned on App Server 1
- Apache installed on App Server 1
- Apache configured to listen on port `8080`
- Load Balancer configured
- `kubectl` or other Kubernetes tools are not required for this task

## App Server 1 Preparation

Connect to App Server 1 from the jump host

```bash
ssh sarah@stapp01
```

Check Java

```bash
java -version
```

If Java is not installed

```bash
sudo dnf install -y java-17-openjdk
```

Verify

```bash
java -version
```

Create the Jenkins agent directory

```bash
mkdir -p /home/sarah/jenkins_agent
```

Verify

```bash
ls -ld /home/sarah/jenkins_agent
```

The directory should be owned by `sarah`.

## Verify the Existing Repository

Move to the application directory

```bash
cd /var/www/html
```

Check the files

```bash
ls -la
```

Verify Git

```bash
git status
```

Check the repository remote

```bash
git remote -v
```

Check the current branch

```bash
git branch --show-current
```

For example

```text
main
```

The branch returned by this command should be used in the Jenkins pipeline.

## Configure Jenkins Agent

Log in to Jenkins using

```text
Username: admin
Password: Adm!n321
```

Navigate to

```text
Manage Jenkins
→ Nodes
→ New Node
```

Create the node

```text
Name: App Server 1
```

Select

```text
Permanent Agent
```

Configure

```text
Remote root directory
/home/sarah/jenkins_agent

Labels:
stapp01

Number of executors
1
```

For the launch method select

```text
Launch agents via SSH
```

Configure

```text
Host: stapp01
Port: 22
Username: sarah
```

Use the appropriate SSH credential for the `sarah` account.

Save the configuration.

## Verify Jenkins Agent

Go to

```text
Manage Jenkins
→ Nodes
```

The node should appear as

```text
App Server 1
```

The label should be

```text
stapp01
```

The remote directory should be

```text
/home/sarah/jenkins_agent
```

The node should eventually show

```text
Connected
```

If the agent fails to start because Java is missing, verify

```bash
java -version
```

on `stapp01`.

## Create Jenkins Pipeline Job

From the Jenkins dashboard select

```text
New Item
```

Enter

```text
nautilus-webapp-job
```

Select

```text
Pipeline
```

Do not select

```text
Multibranch Pipeline
```

Click

```text
OK
```

## Configure the Pipeline

Scroll to the Pipeline section.

Select

```text
Definition:
Pipeline script
```

For a repository using the `main` branch, use

```groovy
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Deploy') {
            steps {
                sh '''
                    cd /var/www/html
                    git pull origin main
                '''
            }
        }
    }
}
```

If the repository uses `master`, change only the branch

```groovy
git pull origin master
```

The pipeline intentionally contains only one stage

```text
Deploy
```

## Save and Build

Click

```text
Save
```

Then select

```text
Build Now
```

Open

```text
Console Output
```

A successful build should end with

```text
Finished: SUCCESS
```

## Verify Deployment

On App Server 1

```bash
cd /var/www/html
```

Check the latest files

```bash
ls -la
```

Check the Git status

```bash
git status
```

Verify Apache

```bash
sudo systemctl status httpd
```

Check port 8080

```bash
ss -lntp | grep 8080
```

Test Apache locally

```bash
curl http://localhost:8080/
```

## Troubleshooting

### Jenkins agent is offline

Check Java

```bash
java -version
```

Check the agent directory

```bash
ls -ld /home/sarah/jenkins_agent
```

Check SSH access from the Jenkins server

```bash
ssh sarah@stapp01
```

Make sure the Jenkins node configuration uses

```text
Host: stapp01
Remote root: /home/sarah/jenkins_agent
Label: stapp01
```

### Pipeline cannot find the node

Make sure the pipeline contains

```groovy
agent {
    label 'stapp01'
}
```

Also verify that the Jenkins node label is exactly

```text
stapp01
```

Labels are case-sensitive.

### `git pull` fails

On App Server 1 run

```bash
cd /var/www/html
git status
```

Then

```bash
git remote -v
```

Check the current branch

```bash
git branch --show-current
```

Test manually

```bash
git pull
```

If the existing repository requires authentication, make sure its existing Git credentials/configuration are still available to the `sarah` user.

### Website is not updated

Check the latest Git commit

```bash
cd /var/www/html
git log -1
```

Check the website

```bash
curl http://localhost:8080/
```

Then verify through the Load Balancer App button.

## Important Configuration Summary

### Jenkins Node

```text
Name: App Server 1
Label: stapp01
Remote root: /home/sarah/jenkins_agent
User: sarah
Host: stapp01
```

### Application

```text
Repository: web_app
Location: /var/www/html
Apache port: 8080
```

### Jenkins Job

```text
Name: nautilus-webapp-job
Type: Pipeline
Multibranch: No
```

### Pipeline Stage

```text
Deploy
```

### Deployment Location

```text
/var/www/html
```

## Main Takeaways

- Jenkins can execute pipeline jobs on remote SSH build agents
- Jenkins agents require a compatible Java runtime
- A dedicated agent directory keeps Jenkins files separate from the application repository
- Jenkins labels can control which node executes a pipeline
- The existing Git repository can be updated directly from the application's document root
- A single-stage pipeline can be used for a simple deployment workflow
- Deploying directly to `/var/www/html` ensures the website is available from the main URL without an additional `/web_app` subdirectory

## Conclusion

The Jenkins pipeline deployment was completed successfully. The required Jenkins agent, pipeline job, deployment configuration, and application environment were set up and verified.
