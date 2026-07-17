# Restore a Git Stash, Commit, and Push Changes

## 1. What is the Challenge?

The objective is to restore a previously stashed set of changes from the Git repository located at:

```text
/usr/src/kodekloudrepos/ecommerce
```

Specifically, restore the stash with identifier:

```text
stash@{1}
```

After restoring the changes:

- Commit the restored changes
- Push the commit to the remote **origin** repository

# 2. Required Technology to Solve It

- Linux
- Git
- Git Stash
- Git Commit
- Git Push

# 3. How to Solve It

### Step 1

SSH into the **Storage Server**.

### Step 2

Navigate to the Git repository.

```bash
cd /usr/src/kodekloudrepos/ecommerce
```

### Step 3

View all available stashes.

```bash
git stash list
```

Example:

```text
stash@{0}: WIP on master...
stash@{1}: WIP on master...
```

### Step 4

Restore the required stash.

```bash
git stash apply stash@{1}
```

> **Note:**  
> Using `apply` restores the changes while keeping the stash.  
> If the task specifically requires removing the stash after restoring, use:

```bash
git stash pop stash@{1}
```

### Step 5

Verify the restored files.

```bash
git status
```

Review the modified files if needed.

```bash
git diff
```

### Step 6

Stage the restored changes.

```bash
git add .
```

### Step 7

Commit the changes.

Example:

```bash
git commit -m "Restore stashed changes"
```

### Step 8

Push the commit to the remote repository.

```bash
git push origin master
```

### Step 9

Verify the repository status.

```bash
git status
```

Expected output:

```text
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

# 4. Main Takeaways

- Learned how to inspect Git stashes
- Restored a specific stash using its identifier
- Understood the difference between `git stash apply` and `git stash pop`
- Committed restored work to the repository
- Pushed the updated repository to the remote origin

# 5. Conclusion

This task demonstrates how Git Stash can temporarily save unfinished work without creating a commit. By restoring the required stash, committing the recovered changes, and pushing them to the remote repository, developers can safely continue previously paused work without losing progress.
