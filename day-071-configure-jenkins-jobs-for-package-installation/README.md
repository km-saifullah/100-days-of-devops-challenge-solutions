# Jenkins Parameterized Job to Install Packages

## 1. Objective

Create a Jenkins job named `install-packages` that accepts a package name through a `PACKAGE` string parameter and installs that package on the Storage server in the Stratos Datacenter.

The job must be tested at least once and should work correctly when executed repeatedly with different package names.

## 2. Login to Jenkins

Click the **Jenkins** button on the top bar.

Login using

```text
Username: admin
Password: Adm!n321
```

## 3. Create Jenkins Job

From the Jenkins dashboard, click

```text
New Item
```

Enter

```text
install-packages
```

Select

```text
Freestyle project
```

Click

```text
OK
```

## 4. Configure String Parameter

In the job configuration, enable

```text
This project is parameterized
```

Click

```text
Add Parameter → String Parameter
```

Configure the parameter

```text
Name: PACKAGE
Description: Package to install on the Storage server
```

The important parameter name is

```text
PACKAGE
```

## 5. Configure Package Installation

Go to

```text
Build Steps → Add build step → Execute shell
```

Add

```bash
ssh -o StrictHostKeyChecking=no root@ststor01 "yum install -y $PACKAGE"
```

The `$PACKAGE` variable receives its value from the Jenkins string parameter.

For example, if the build is executed with

```text
vim-enhanced
```

Jenkins executes

```bash
ssh -o StrictHostKeyChecking=no root@ststor01 "yum install -y vim-enhanced"
```

## 6. Save the Job

Click

```text
Save
```

The Jenkins job should now be available as

```text
install-packages
```

## 7. Build the Job

Open

```text
install-packages
```

Click

```text
Build with Parameters
```

Enter

```text
PACKAGE=vim-enhanced
```

Click

```text
Build
```

## 8. Check Build Output

Open the build and select

```text
Console Output
```

Verify that

- Jenkins successfully connects to the Storage server
- The package installation command executes
- The build finishes successfully

The build should end with

```text
Finished: SUCCESS
```

## 9. Verify Package Installation

Connect to the Storage server and verify the package

You can also check

```bash
vim --version
```

The package should be installed successfully.

## 10. Test Repeated Execution

Run the Jenkins job again using:

```text
Build with Parameters
```

For example

```text
git
```

Click

```text
Build
```

Verify the build completes successfully again.

This confirms that the Jenkins job dynamically uses the `PACKAGE` parameter and is not hardcoded to a single package.

## 11. Troubleshooting

### SSH Host Key Error

If Jenkins reports an SSH host key verification error, use:

```bash
ssh -o StrictHostKeyChecking=no root@ststor01 "yum install -y $PACKAGE"
```

The `StrictHostKeyChecking=no` option allows the Jenkins build to connect without an interactive host-key confirmation.

### SSH Permission Error

If SSH authentication fails, verify that the Jenkins server has the required SSH access to the Storage server.

Test from the Jenkins server

```bash
ssh root@ststor01
```

**On Jenkins server**
Switch to the Jenkins user

```bash
sudo -u jenkins -H bash
```

Generate an SSH key

```bash
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
```

Show the public key

```bash
cat ~/.ssh/id_rsa.pub
```

**On Storage server**
Log in to ststor01 using the appropriate existing access method and add the Jenkins public key to

```bash
mkdir -p /root/.ssh
chmod 700 /root/.ssh
vi /root/.ssh/authorized_keys
```

Then change the permission of the `authorized_keys` file

```bash
chmod 600 /root/.ssh/authorized_keys
```

Test again from the Jenkins server

```bash
ssh root@ststor01
```

This time it will login automatically.

### Package Installation Error

Check the Jenkins **Console Output** for the exact package manager error.

Also verify that the package name supplied through `PACKAGE` is valid for the Storage server.

## 12. Final Verification

- Jenkins job is named `install-packages`
- The job is parameterized
- The parameter is named `PACKAGE`
- The job connects to the Storage server
- The package name comes from `$PACKAGE`
- `vim-enhanced` was successfully installed
- The package can be verified on the Storage server
- The job succeeds on repeated executions
- The Jenkins build finishes with `Finished: SUCCESS`

## Conclusion

The `install-packages` Jenkins job was created as a parameterized job. It accepts the package name through the `PACKAGE` parameter and installs the requested package on the Storage server. The job was tested with `vim-enhanced` and can be reused for installing other required packages.
