# Jenkins Pipeline Deployment with Branch Selection

## Objective

Create a Jenkins Pipeline job to deploy a static website from the existing `web_app` Git repository to Nautilus App Server 1.

The deployment must support two branches:

- `master`
- `feature`

The branch to deploy is selected through a Jenkins string parameter named `BRANCH`.

The application must be deployed directly to

```text
/var/www/html
```

The Jenkins job must contain exactly one stage named

```text
Deploy
```

## Infrastructure

| Component               | Details                     |
| ----------------------- | --------------------------- |
| Jenkins Server          | Jenkins                     |
| Jenkins User            | admin                       |
| App Server              | stapp01                     |
| App Server User         | sarah                       |
| Repository              | web_app                     |
| Repository Location     | `/var/www/html`             |
| Jenkins Agent Directory | `/home/sarah/jenkins_agent` |
| Agent Label             | `stapp01`                   |
| Apache Port             | `8080`                      |
| Pipeline Job            | `nautilus-webapp-job`       |

## Required Jenkins Plugins

The following Jenkins plugins are required:

- Pipeline
- SSH Build Agents
- Git

### Install Plugins

Open

```text
Jenkins
→ Manage Jenkins
→ Plugins
→ Available plugins
```

Search for

```text
Pipeline
```

Install it.

Search for

```text
SSH Build Agents
```

Install it.

Search for

```text
Git
```

Install it.

If Jenkins asks for a restart, select

```text
Restart Jenkins when installation is complete and no jobs are running
```

Wait until Jenkins comes back online and refresh the browser.

## 4. Prepare App Server 1

Connect to App Server 1

```bash
ssh sarah@stapp01
```

Verify Java

```bash
java -version
```

If Java is not installed

```bash
sudo dnf install -y java-17-openjdk
```

Create the Jenkins agent directory

```bash
mkdir -p /home/sarah/jenkins_agent
```

## Verify the Existing Repository

The repository is already cloned at

```text
/var/www/html
```

Go to the repository

```bash
cd /var/www/html
```

Check the Git status

```bash
git status
```

Check the remote

```bash
git remote -v
```

Check available branches

```bash
git branch -a
```

The required branches are

```text
master
feature
```

## Fix Git Safe Directory if Required

If Git displays

```text
fatal: detected dubious ownership in repository at '/var/www/html'
```

run the following command as the `sarah` user

```bash
git config --global --add safe.directory /var/www/html
```

Then verify

```bash
cd /var/www/html
git status
```

The repository should now be accessible to the Jenkins agent user.

## Create the Jenkins Agent

Go to

```text
Manage Jenkins
→ Nodes
→ New Node
```

Create

```text
App Server 1
```

Select

```text
Permanent Agent
```

Configure the node as follows

### Node Name

```text
App Server 1
```

### Remote Root Directory

```text
/home/sarah/jenkins_agent
```

### Labels

```text
stapp01
```

### Executors

```text
1
```

### Launch Method

Select

```text
Launch agents via SSH
```

Configure

```text
Host: stapp01
Port: 22
```

Use the `sarah` credentials for App Server 1.

After saving the configuration, verify that the node is online.

## Verify the Jenkins Agent

Open

```text
Manage Jenkins
→ Nodes
→ App Server 1
→ Log
```

The connection should show successful SSH authentication and the agent should become online.

The node must show an online/green status before running the Pipeline.

## Create the Pipeline Job

Go to

```text
Dashboard
→ New Item
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

## Configure the BRANCH Parameter

Enable

```text
This project is parameterized
```

Add

```text
String Parameter
```

Configure

```text
Name: BRANCH
```

The parameter accepts

```text
master
```

or

```text
feature
```

## Configure the Pipeline

Under the Pipeline section select

```text
Definition
Pipeline script
```

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

                    cd /var/www/html

                    if [ "$BRANCH" = "master" ]; then
                        git fetch origin
                        git checkout master
                        git reset --hard origin/master

                    elif [ "$BRANCH" = "feature" ]; then
                        git fetch origin
                        git checkout feature
                        git reset --hard origin/feature

                    else
                        echo "Invalid branch: $BRANCH"
                        echo "Allowed values: master or feature"
                        exit 1
                    fi

                    echo "Successfully deployed branch: $BRANCH"
                    git branch --show-current
                    git log -1 --oneline
                '''
            }
        }
    }
}
```

Save the configuration.

## Test the Master Branch

Click

```text
Build with Parameters
```

Set

```text
master
```

Click:

```text
Build
```

The build should complete successfully.

Verify from App Server 1

```bash
cd /var/www/html
git branch --show-current
```

Expected

```text
master
```

## Test the Feature Branch

Run the Pipeline again using

```text
feature
```

The build should complete successfully.

Verify

```bash
cd /var/www/html
git branch --show-current
```

Expected

```text
feature
```

## Verify the Deployment

Apache is already configured on App Server 1 and listens on port

```text
8080
```

The deployed files are located directly under

```text
/var/www/html
```

Use the KodeKloud **App** button to verify the application.

The website should be available from the main load balancer URL

```text
https://<LBR-URL>
```

The application should not require

```text
/web_app
```

The repository contents must be served directly from the document root.

## Troubleshooting

### Pipeline option is missing

If `Pipeline` does not appear under

```text
Dashboard → New Item
```

install the

```text
Pipeline
```

plugin and restart Jenkins.

### Launch agents via SSH is missing

Install

```text
SSH Build Agents
```

Then restart Jenkins.

After restarting, create the node again and select

```text
Launch agents via SSH
```

### Java version error on the agent

Check

```bash
java -version
```

Install Java if necessary

```bash
sudo dnf install -y java-17-openjdk
```

Then verify

```bash
java -version
```

### Git dubious ownership error

If you see

```text
fatal: detected dubious ownership in repository
```

run as `sarah`

```bash
git config --global --add safe.directory /var/www/html
```

Then

```bash
cd /var/www/html
git status
```

### Permission denied while accessing `/var/www/html`

Check

```bash
ls -ld /var/www/html
```

The Jenkins agent must be able to access and modify the repository as the `sarah` user. Do not run the Jenkins Pipeline with `sudo` unless the task explicitly requires it.

## Verification Checklist

- [x] Jenkins Pipeline plugin installed
- [x] SSH Build Agents plugin installed
- [x] Git plugin installed
- [x] Java installed on App Server 1
- [x] Jenkins agent named `App Server 1`
- [x] Agent label set to `stapp01`
- [x] Remote root set to `/home/sarah/jenkins_agent`
- [x] App Server 1 agent online
- [x] Existing repository located at `/var/www/html`
- [x] Jenkins job named `nautilus-webapp-job`
- [x] Job type is Pipeline
- [x] Job is not Multibranch Pipeline
- [x] String parameter named `BRANCH`
- [x] `master` branch deployment tested
- [x] `feature` branch deployment tested
- [x] Pipeline contains a single stage named `Deploy`
- [x] Application deployed directly to `/var/www/html`
- [x] Application verified through the App button

## Conclusion

The Jenkins Pipeline deployment task was completed successfully. The required Jenkins agent, pipeline configuration, branch-based deployment, and application deployment setup were configured and verified.
