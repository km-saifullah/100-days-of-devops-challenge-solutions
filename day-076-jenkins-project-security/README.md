# Jenkins Project-Based Permissions for Developers

## Objective

The objective of this task is to configure job-level permissions for two existing Jenkins users on the existing `Packages` job.

The required permissions are

- `sam`: Read, Build, Configure
- `rohan`: Read, Build, Cancel, Configure, Update, Tag

The project should use the **Project-based Matrix Authorization Strategy**, with permissions inherited from the parent ACL.

## Requirements

### Jenkins Credentials

Jenkins administrator:

```text
Username: admin
Password: Adm!n321
```

### Existing Users

#### Sam

```text
Username: sam
Password: sam@pass12345
```

Required permissions

```text
Read
Build
Configure
```

#### Rohan

```text
Username: rohan
Password: rohan@pass12345
```

Required permissions

```text
Read
Build
Cancel
Configure
Update
Tag
```

### Existing Job

```text
Packages
```

Do not modify any other existing job configuration.

## 3. Required Plugin

The Jenkins server requires the following plugin

```text
Matrix Authorization Strategy
```

## Install the Required Plugin

Login to Jenkins using the administrator account

```text
Username: admin
Password: Adm!n321
```

Navigate to

```text
Manage Jenkins
    ↓
Plugins
    ↓
Available plugins
```

Search for

```text
Matrix Authorization Strategy
```

Install the plugin.

If Jenkins asks for a restart, select

```text
Restart Jenkins when installation is complete and no jobs are running
```

Wait for Jenkins to restart completely.

Refresh the browser and log in again if necessary.

## Configure the Global Security

1. Go to global security

Open **Manage Jenkins → Security**

Find **Authorization**. You need to change the authorization option to `Project-based Matrix Authorization Strategy`

It should become available after the Matrix Authorization Strategy plugin is correctly loaded.

2. Save the global configuration

After selecting `Project-based Matrix Authorization Strategy` make sure your admin user retains `Overall → Administer`

Then click **Save**

> Do not remove your admin permissions, otherwise you could lock yourself out.
> Also give the authenticated user overall permission read.

## Configure the Packages Job

Navigate to

```text
Dashboard
    ↓
Packages
    ↓
Configure
```

Locate the authorization/security section.

Select

```text
Project-based Matrix Authorization Strategy
```

This allows permissions to be configured specifically for the `Packages` job.

## Configure Sam Permissions

Add the existing user

```text
sam
```

Grant only the following Job permissions

```text
Job → Read
Job → Build
Job → Configure
```

The permission matrix should effectively contain

```text
sam
 ├── Read       ✓
 ├── Build      ✓
 └── Configure  ✓
```

All other permissions for `sam` should remain disabled.

## Configure Rohan Permissions

Add the existing user

```text
rohan
```

Grant the following Job permissions

```text
Job → Read
Job → Build
Job → Cancel
Job → Configure
Job → Update
Job → Tag
```

The permission matrix should effectively contain

```text
rohan
 ├── Read       ✓
 ├── Build      ✓
 ├── Cancel     ✓
 ├── Configure  ✓
 ├── Update     ✓
 └── Tag        ✓
```

All other unrelated permissions should remain disabled.

## Configure Permission Inheritance

Set the inheritance strategy to

```text
Inherit permissions from parent ACL
```

This is an important requirement of the task. Do not select an option that prevents the project from inheriting permissions from its parent ACL.

## Save the Configuration

After verifying the permission matrix, click

```text
Save
```

Make sure no other configuration of the `Packages` job has been changed.

## Permission Verification

The final permissions should be:

| User  | Read | Build | Cancel | Configure | Update | Tag |
| ----- | ---- | ----- | ------ | --------- | ------ | --- |
| sam   | ✓    | ✓     | ✗      | ✓         | ✗      | ✗   |
| rohan | ✓    | ✓     | ✓      | ✓         | ✓      | ✓   |

### Sam

Login using

```text
Username: sam
Password: sam@pass12345
```

Verify that Sam can access and build the `Packages` job and has Configure permission.

### Rohan

Login using

```text
Username: rohan
Password: rohan@pass12345
```

Verify that Rohan has all six required Job permissions.

## Verification Checklist

Before finishing the task, verify

```text
[✓] Matrix Authorization Strategy plugin installed
[✓] Packages job configured with Project-based Matrix Authorization Strategy
[✓] Inherit permissions from parent ACL selected
[✓] sam added to Packages job
[✓] sam has Read permission
[✓] sam has Build permission
[✓] sam has Configure permission
[✓] rohan added to Packages job
[✓] rohan has Read permission
[✓] rohan has Build permission
[✓] rohan has Cancel permission
[✓] rohan has Configure permission
[✓] rohan has Update permission
[✓] rohan has Tag permission
[✓] No unnecessary permissions granted
[✓] Existing job configuration was not altered
```

## Important Notes

- Do not create new users because `sam` and `rohan` already exist
- Do not change their passwords
- Do not modify other Jenkins jobs
- Do not grant unnecessary Overall, Agent, SCM, or Credentials permissions
- Make sure the inheritance strategy is **Inherit permissions from parent ACL**
- If Jenkins is restarted after plugin installation, wait until the login page is available again before continuing
- Refresh the browser if the Jenkins UI appears stuck after the restart
- Screenshots of the permission matrix can be captured for documentation and review

## Conclusion

The `Packages` Jenkins job was configured with the required project-based permissions for the `sam` and `rohan` users. The specified permissions were assigned and the configuration was verified successfully.
