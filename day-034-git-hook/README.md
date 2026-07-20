# Setup a Git Post-Update Hook for Automatic Release Tags

## 1. What is the Challenge?

The objective is to configure a **Git hook** in the repository so that whenever changes are pushed to the **master** branch, Git automatically creates a release tag using the current date.

Additionally:

- Merge the **feature** branch into **master**
- Configure the **post-update** hook
- Test the hook by pushing changes
- Ensure a release tag is created
- Push all changes to the remote repository

> **Note:** Perform all operations as the **natasha** user without changing repository ownership or permissions.

# 2. Required Technology to Solve It

- Linux
- Git
- Git Hooks
- Bash Scripting

### Repository

```text
/opt/demo.git
```

Local Clone

```text
/usr/src/kodekloudrepos/demo
```

# 3. How to Solve It

### Step 1

SSH into the **Storage Server** as **natasha**.

```bash
ssh natasha@ststor01
```

### Step 2

Navigate to the repository.

```bash
cd /usr/src/kodekloudrepos/demo
```

### Step 3

Verify the available branches.

```bash
git branch
```

### Step 4

Switch to the **master** branch.

```bash
git checkout master
```

### Step 5

Merge the **feature** branch.

```bash
git merge feature
```

Resolve conflicts if prompted.

### Step 6

Create the **post-update** hook.

```bash
vi .git/hooks/post-update
```

Add the following script:

```bash
#!/bin/bash

cd /usr/src/kodekloudrepos/demo || exit 1

TAG="release-$(date +%F)"

git tag -f "$TAG"

git push origin "$TAG"
```

Save and exit.

### Step 7

Make the hook executable.

```bash
chmod +x .git/hooks/post-update
```

### Step 8

Push the master branch.

```bash
git push origin master
```

The hook should automatically create a tag similar to:

```text
release-2026-07-20
```

### Step 9

Verify the tag.

```bash
git tag
```

Expected output:

```text
release-YYYY-MM-DD
```

### Step 10

Verify on the remote repository.

```bash
git ls-remote --tags origin
```

# 4. Main Takeaways

- Learned how Git hooks automate repository tasks
- Configured a **post-update** hook
- Merged a feature branch into master
- Automatically generated release tags using the current date
- Pushed both commits and tags to the remote repository

# 5. Conclusion

This task demonstrates how Git hooks can automate repetitive release activities. By configuring a **post-update** hook, every push to the **master** branch automatically creates a release tag with the current date, simplifying release management and ensuring consistent version tagging.
