# Rebase a Feature Branch with Master and Push Changes

## 1. What is the Challenge?

The objective is to update the **feature** branch with the latest changes from the **master** branch without creating a merge commit. Instead of merging, perform a **Git rebase** so that the feature branch history remains clean and linear.

After the rebase is completed successfully, push the updated **feature** branch to the remote repository.

# 2. Required Technology to Solve It

- Linux
- Git
- Git Branches
- Git Rebase
- Git Push

# 3. How to Solve It

### Step 1

SSH into the **Storage Server**.

### Step 2

Navigate to the Git repository.

```bash
cd /usr/src/kodekloudrepos/apps
```

### Step 3

Verify the available branches.

```bash
git branch
```

Expected output:

```text
* master
  feature
```

### Step 4

Update the local **master** branch.

```bash
git checkout master
```

Pull the latest changes.

```bash
git pull origin master
```

### Step 5

Switch to the **feature** branch.

```bash
git checkout feature
```

### Step 6

Rebase the feature branch onto master.

```bash
git rebase master
```

If there are no conflicts, Git will replay the feature branch commits on top of the latest master branch.

### Step 7 (Only if conflicts occur)

Check conflicted files.

```bash
git status
```

Edit the files and resolve the conflicts.

Stage the resolved files.

```bash
git add .
```

Continue the rebase.

```bash
git rebase --continue
```

Repeat until the rebase finishes.

If you want to cancel the rebase:

```bash
git rebase --abort
```

### Step 8

Verify the commit history.

```bash
git log --oneline --graph --all
```

The feature branch should now sit on top of the latest master branch without a merge commit.

### Step 9

Push the rebased feature branch to the remote repository.

Since the history has changed, use:

```bash
git push origin feature --force-with-lease
```

> If the KodeKloud lab does not accept `--force-with-lease`, use:

```bash
git push origin feature --force
```

### Step 10

Verify the repository status.

```bash
git status
```

Expected output:

```text
On branch feature
Your branch is up to date with 'origin/feature'.

nothing to commit, working tree clean
```

# 4. Main Takeaways

- Learned the difference between **merge** and **rebase**
- Updated a feature branch without creating an extra merge commit
- Maintained a clean and linear Git history
- Learned how to resolve conflicts during a rebase
- Successfully pushed a rewritten branch history to the remote repository

# 5. Conclusion

This task demonstrates the use of **Git Rebase** to synchronize a feature branch with the latest changes from the master branch while preserving a clean commit history. Rebasing is a common workflow in professional DevOps and software development teams because it avoids unnecessary merge commits and makes project history easier to understand.
