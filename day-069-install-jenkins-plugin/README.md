# Install Git and GitLab Plugins in Jenkins

## 1. Objective

Install the required **Git** and **GitLab** plugins in the Jenkins server so they can be used for CI/CD jobs.

## 2. Login to Jenkins

Click the **Jenkins** button on the top bar.

Login using

```text
Username: admin
Password: Adm!n321
```

## 3. Open Plugin Manager

From the Jenkins dashboard, go to

```text
Manage Jenkins
```

Then open

```text
Plugins
```

## 4. Install Git Plugin

Open the

```text
Available plugins
```

tab.

Search for

```text
Git
```

Select the **Git** plugin.

Click

```text
Install
```

## 5. Install GitLab Plugin

Search for

```text
GitLab
```

Select the **GitLab** plugin.

Click

```text
Install
```

## 6. Restart Jenkins if Required

If Jenkins asks for a restart after the plugin installation, select

```text
Restart Jenkins when installation is complete and no jobs are running
```

Wait for Jenkins to restart completely. **Do not continue until the Jenkins login page appears again.**

## 7. Verify the Plugins

Log in to Jenkins again using

```text
Username: admin
Password: Adm!n321
```

Go to

```text
Manage Jenkins → Plugins → Installed plugins
```

## 8. Final Verification

- Jenkins login is working
- Git plugin is installed
- GitLab plugin is installed
- Jenkins has restarted successfully if required
- The Jenkins login page is available after the restart

## Conclusion

The required Git and GitLab plugins were installed successfully in Jenkins and verified from the Installed Plugins section.
