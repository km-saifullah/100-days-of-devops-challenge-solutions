# Install and Configure Jenkins

## 1. Objective

Install Jenkins on the Jenkins server using the `apt` package manager, install the required Java version, configure the Jenkins Long Term Support repository, and start Jenkins successfully.

The required Jenkins administrator account is:

```text
Username: theadmin
Password: Adm!n321
Full Name: Anita
Email: anita@jenkins.stratos.xfusioncorp.com
```

## 2. Update APT Repositories and Install OpenJDK 21

Update the Debian package repositories

```bash
sudo apt update
```

Install OpenJDK 21

```bash
sudo apt install fontconfig openjdk-21-jre
```

Verify the Java installation

```bash
java -version
```

## 3. Configure Jenkins Long Term Support Repository

Download the Jenkins repository key

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
```

Add the Jenkins Long Term Support repository

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

Update the package repositories

```bash
sudo apt update
```

Install Jenkins

```bash
sudo apt install jenkins
```

## 4. Start Jenkins

Enable Jenkins to start automatically

```bash
sudo systemctl enable jenkins
```

Start the Jenkins service

```bash
sudo systemctl start jenkins
```

Check the Jenkins service status

```bash
sudo systemctl status jenkins
```

The Jenkins service should be in an active and running state.

## 5. Access Jenkins UI

After Jenkins starts successfully, click the **Jenkins** button on the top bar to open the Jenkins web interface.

Follow the on-screen setup instructions. If the initial administrator password is required, retrieve it with

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Use the displayed password to continue the initial Jenkins setup.

## 6. Create Jenkins Administrator

Create the administrator account with the following details

```text
Username: theadmin
Password: Adm!n321
Full Name: Anita
Email: anita@jenkins.stratos.xfusioncorp.com
```

Complete the Jenkins setup wizard.

## 7. Verify Jenkins

Check the Jenkins service

```bash
sudo systemctl status jenkins
```

Jenkins should show an active running status. You can also verify that Jenkins is listening on its default port

```bash
sudo ss -lntp | grep 8080
```

## 8. Final Verification

- OpenJDK 21 is installed
- Jenkins LTS repository is configured
- Jenkins is installed successfully
- Jenkins service is enabled
- Jenkins service is running
- Jenkins UI is accessible
- The required administrator account has been created

## Conclusion

Jenkins was successfully installed and configured according to the required setup. The required Java version and Jenkins LTS repository were configured, Jenkins was started and verified, and the administrator account was created through the Jenkins UI.
