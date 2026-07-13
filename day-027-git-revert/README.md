# Revert the Latest Git Commit

## 1. What is the Challenge?

The objective is to revert the **latest commit (HEAD)** in the existing Git repository located at:

```text
/usr/src/kodekloudrepos/demo
```

The latest commit should be reverted so that the repository returns to the state of the **previous commit** (whose commit message is **"initial commit"**). The revert must create a **new commit** with the following commit message:

```text
revert demo
```

> **Note:** Do not reset the repository history. Use **git revert**, which preserves the commit history by creating a new commit.

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
cd /usr/src/kodekloudrepos/demo
```

### Step 3

Verify the commit history.

```bash
git log --oneline
```

You should see the latest commit above the **initial commit**.

### Step 4

Revert the latest commit.

```bash
git revert HEAD
```

### Step 5

When the editor opens, replace the default commit message with:

```text
revert demo
```

Save and exit the editor.

For **vi/vim**:

```text
Press i
Edit the message
Press Esc
Type :wq
Press Enter
```

### Step 6

Verify that the new revert commit has been created.

```bash
git log --oneline
```

Expected output:

```text
<new_hash> revert revert demo
<old_hash> Latest Commit
<initial_hash> initial commit
```

# 4. Main Takeaways

- Learned the difference between **git revert** and **git reset**
- Used **git revert** to safely undo changes while preserving Git history
- Created a new commit that reverses the changes introduced by the latest commit
- Practiced viewing commit history using **git log**
- Understood why **git revert** is preferred for shared repositories

# 5. Conclusion

This task demonstrates how to safely undo the most recent commit using **git revert**. Unlike **git reset**, which rewrites commit history, **git revert** creates a new commit that reverses the previous changes. This approach is recommended for collaborative environments because it preserves the repository history while effectively undoing unwanted changes.
