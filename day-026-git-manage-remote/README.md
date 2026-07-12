# Configure a New Git Remote and Push Changes

## 1. What is the Challenge?

The objective is to update the existing Git repository located at:

```text
/usr/src/kodekloudrepos/apps
```

The following tasks must be completed:

- Add a new Git remote named **dev_apps** pointing to:

```text
/opt/xfusioncorp_apps.git
```

- Copy the **/tmp/index.html** file into the repository
- Add and commit the file on the **master** branch
- Push the **master** branch to the newly created remote repository

# 2. Required Technology to Solve It

- **Linux**
- **Git**
- **Git Repository**
- **Bash Terminal**

# 3. How to Solve It

### Step 1

Log in to the **Storage Server**.

### Step 2

Navigate to the Git repository.

```bash
cd /usr/src/kodekloudrepos/apps
```

### Step 3

Ensure you are on the **master** branch.

```bash
git checkout master
```

### Step 4

Add the new Git remote.

```bash
git remote add dev_apps /opt/xfusioncorp_apps.git
```

### Step 5

Verify the configured remotes.

```bash
git remote -v
```

Expected output:

```text
dev_apps    /opt/xfusioncorp_apps.git (fetch)
dev_apps    /opt/xfusioncorp_apps.git (push)
origin      ...
```

### Step 6

Copy the provided file into the repository.

```bash
cp /tmp/index.html .
```

### Step 7

Verify the repository status.

```bash
git status
```

### Step 8

Stage the new file.

```bash
git add index.html
```

### Step 9

Commit the changes.

```bash
git commit -m "Add index.html"
```

### Step 10

Push the **master** branch to the newly created remote.

```bash
git push dev_apps master
```

### Step 11

Verify that the remote is configured correctly.

```bash
git remote -v
```

# 4. Main Takeaways

- Learned how to configure an additional Git remote
- Understood the difference between multiple Git remotes
- Practiced copying project files into an existing repository
- Learned how to stage and commit changes on the master branch
- Successfully pushed changes to a specific remote repository instead of the default origin
- Reinforced Git remote management for collaborative development

# 5. Conclusion

This task demonstrates how to work with multiple Git remotes in a single repository. After configuring the new remote, the required file was added and committed to the master branch, and the updated branch was pushed to the specified remote repository. Managing multiple remotes is a common practice when working with mirrors, deployment repositories, or multiple development environments.
