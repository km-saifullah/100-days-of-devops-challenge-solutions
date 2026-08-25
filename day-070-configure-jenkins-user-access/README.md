# Configure Jenkins User Access with Project-Based Matrix Authorization

## 1. Objective

Create a Jenkins user named `yousuf` and configure project-based permissions so that the user has only the required read access.

The Jenkins administrator must retain full administrative access, while anonymous users must have no permissions.

## 2. Login to Jenkins

Click the **Jenkins** button on the top bar.

Login using

```text
Username: admin
Password: Adm!n321
```

## 3. Install Matrix Authorization Strategy Plugin

If **Project-based Matrix Authorization Strategy** is not available in the Authorization dropdown, the required plugin must be installed first.

Go to

```text
Manage Jenkins → Plugins
```

Open

```text
Available plugins
```

Search for

```text
Matrix Authorization Strategy
```

Select the **Matrix Authorization Strategy** plugin and install it.

If Jenkins provides the option

```text
Restart Jenkins when installation is complete and no jobs are running
```

select it.

Wait for Jenkins to restart completely.

**Do not continue until the Jenkins login page appears again.**

Login again using

```text
Username: admin
Password: Adm!n321
```

## 4. Create Jenkins User

Go to:

```text
Manage Jenkins → Users → Create User
```

Create the following user:

```text
Username: yousuf
Password: dCV3szSGNA
Full Name: Yousuf
```

Create the user.

## 5. Configure Project-Based Matrix Authorization

Go to

```text
Manage Jenkins → Security
```

Under **Authorization**, look for

```text
Project-based Matrix Authorization Strategy
```

Select it.

> If only the following options are visible:
>
> - Logged in users can do anything
> - Anyone can do anything
> - Legacy mode
>
> the Matrix Authorization Strategy plugin has not been installed or Jenkins has not been restarted after installation.

## 6. Configure Global Permissions

Add the `admin` user and make sure it has

```text
Overall → Administer
```

Add the `yousuf` user and grant only

```text
Overall → Read
```

If `Anonymous` is listed, remove all permissions from it.

The required global permission setup is

| User      | Overall Read | Overall Administer |
| --------- | -----------: | -----------------: |
| admin     |            ✓ |                  ✓ |
| yousuf    |            ✓ |                  ✗ |
| Anonymous |            ✗ |                  ✗ |

Do not give `yousuf` any additional global permissions.

Save the Jenkins security configuration.

## 7. Configure Existing Job

Open the existing Jenkins job.

Go to

```text
Configure
```

Enable

```text
Enable project-based security
```

Add the user (**yousuf**) below and grant only **read** access for the job

Save the job configuration.

## 8. Verify Yousuf's Access

Log out from the administrator account and login using

```text
Username: yousuf
Password: dCV3szSGNA
```

Verify that `yousuf` can

- Log in to Jenkins
- View Jenkins
- See the permitted existing job
- Read/view the job

Verify that `yousuf` cannot

- Build the job
- Configure the job
- Delete the job
- Cancel builds
- Modify the job

## 9. Final Verification

- Matrix Authorization Strategy plugin is installed
- Jenkins has been restarted if required
- Project-based Matrix Authorization Strategy is selected
- User `yousuf` exists
- User `yousuf` has **Overall → Read** permission
- User `yousuf` does not have **Overall → Administer** permission
- Anonymous users have no permissions
- `admin` retains **Overall → Administer** permission
- The existing job uses project-based security
- `yousuf` has only **Job → Read** permission on the existing job
- No Agent, SCM, Build, Configure, Delete, or other unnecessary permissions are granted to `yousuf`
- `yousuf` can successfully log in and view the existing job

## Conclusion

The Jenkins user access was configured using the Project-based Matrix Authorization Strategy. The required authorization plugin was installed, `yousuf` was created with read-only access, anonymous permissions were removed, and the `admin` user retained full administrative access.
