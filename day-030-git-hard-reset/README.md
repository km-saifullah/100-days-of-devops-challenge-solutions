# Reset Git History to a Previous Commit and Push Changes

## 1. What is the Challenge?

The objective is to clean the Git repository by removing the recent testing commits and resetting the repository history back to the commit with the message:

```text
add data.txt file
```

After the reset, the repository should contain **only two commits**:

1. `initial commit`
2. `add data.txt file`

Finally, the rewritten history must be pushed to the remote repository.

# 2. Required Technology to Solve It

- Linux
- Git
- Git Reset
- Git Log
- Force Push

# 3. How to Solve It

### Step 1

SSH into the **Storage Server**.

### Step 2

Navigate to the repository.

```bash
cd /usr/src/kodekloudrepos/apps
```

### Step 3

View the commit history.

```bash
git log --oneline
```

Locate the commit whose message is:

```text
add data.txt file
```

Copy its commit hash.

### Step 4

Reset the repository back to that commit.

```bash
git reset --hard <commit-id>
```

Example:

```bash
git reset --hard a1b2c3d
```

This removes all commits made after **add data.txt file**.

### Step 5

Verify the commit history.

```bash
git log --oneline
```

Expected output:

```text
add data.txt file
initial commit
```

Only these two commits should remain.

### Step 6

Force push the rewritten history to the remote repository.

```bash
git push origin master --force
```

or

```bash
git push --force origin master
```

### Step 7

Verify that the push completed successfully.

(Optional)

```bash
git status
```

Expected:

```text
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

# 4. Main Takeaways

- Learned how to inspect Git commit history
- Used `git reset --hard` to move the branch back to a previous commit
- Removed unwanted commits from the repository history
- Used `git push --force` to update the remote repository after rewriting history
- Understood when rewriting Git history is appropriate (such as cleaning up a test repository)

# 5. Conclusion

This task demonstrates how to permanently remove unwanted commits from a Git repository by resetting the branch to an earlier commit. After verifying that only the required commits remain, the updated history is synchronized with the remote repository using a force push.
