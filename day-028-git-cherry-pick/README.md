# Cherry-Pick a Commit from Feature Branch to Master

## 1. What is the Challenge?

The objective is to merge **only one specific commit** from the **feature** branch into the **master** branch in the Git repository located at:

```text
/usr/src/kodekloudrepos/media
```

The commit to be merged is identified by its commit message:

```text
Update info.txt
```

Instead of merging the entire **feature** branch, only this single commit should be applied to **master** using **git cherry-pick**. Finally, push the updated **master** branch to the remote repository.

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
cd /usr/src/kodekloudrepos/media
```

### Step 3

View the commit history of the **feature** branch.

```bash
git log feature --oneline
```

or search directly for the required commit.

```bash
git log feature --oneline --grep="Update info.txt"
```

Example output:

```text
3f2ab9d Update info.txt
```

### Step 4

Switch to the **master** branch.

```bash
git checkout master
```

### Step 5

Cherry-pick the required commit.

```bash
git cherry-pick 3f2ab9d
```

> Replace **3f2ab9d** with the actual commit hash from your repository.

### Step 6

Verify that the commit now exists on the **master** branch.

```bash
git log --oneline
```

### Step 7

Push the updated **master** branch to the remote repository.

```bash
git push origin master
```

# 4. Main Takeaways

- Learned how to transfer a single commit between branches using **git cherry-pick**
- Understood the difference between **merge** and **cherry-pick**
- Practiced locating commits using **git log** and **--grep**
- Successfully applied only the required change without merging the entire feature branch
- Pushed the updated master branch to the remote repository

# 5. Conclusion

This task demonstrates how to selectively merge a specific commit from one branch into another using **git cherry-pick**. This technique is particularly useful when only a single bug fix or feature should be moved into another branch without bringing along all other in-progress changes.
