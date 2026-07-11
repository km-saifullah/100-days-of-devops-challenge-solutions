# Create, Merge, and Push a Git Branch

## 1. What is the Challenge?

The objective is to update the existing Git repository located at:

```text
/usr/src/kodekloudrepos/news
```

The following tasks must be completed:

- Create a new branch named **nautilus** from the **master** branch
- Copy the **/tmp/index.html** file into the repository
- Add and commit the new file in the **nautilus** branch
- Merge the **nautilus** branch back into the **master** branch
- Push both the **master** and **nautilus** branches to the remote origin repository

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
cd /usr/src/kodekloudrepos/news
```

### Step 3

Ensure you are on the **master** branch.

```bash
git checkout master
```

### Step 4

Create and switch to the **nautilus** branch.

```bash
git checkout -b nautilus
```

### Step 5

Copy the provided file into the repository.

```bash
cp /tmp/index.html .
```

### Step 6

Verify the repository status.

```bash
git status
```

### Step 7

Stage the file.

```bash
git add index.html
```

### Step 8

Commit the changes.

```bash
git commit -m "Add index.html"
```

### Step 9

Switch back to the **master** branch.

```bash
git checkout master
```

### Step 10

Merge the **nautilus** branch into **master**.

```bash
git merge nautilus
```

### Step 11

Push the **master** branch to the remote repository.

```bash
git push origin master
```

### Step 12

Push the **nautilus** branch to the remote repository.

```bash
git push origin nautilus
```

### Step 13

Verify that both branches exist.

```bash
git branch
```

Expected output:

```text
* master
  nautilus
```

# 4. Main Takeaways

- Learned how to create a feature branch from the master branch
- Practiced copying project files into a Git repository
- Learned how to stage and commit changes
- Understood how to merge a feature branch into the master branch
- Learned how to push multiple branches to a remote Git repository
- Reinforced a common Git workflow used in collaborative software development

# 5. Conclusion

This task demonstrates a complete Git development workflow. A new feature branch was created, a new file was added and committed, the changes were merged into the master branch, and both branches were pushed to the remote repository. This branching strategy allows developers to work safely on new features while keeping the main branch stable.
