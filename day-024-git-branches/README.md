# Create a New Git Branch in an Existing Repository

## 1. What is the Challenge?

The objective is to create a new Git branch named **`xfusioncorp_ecommerce`** from the **master** branch in the existing Git repository located at:

```text
/usr/src/kodekloudrepos/ecommerce
```

The repository already exists on the **Storage Server**. No source code or repository files should be modified. Only a new branch should be created.

# 2. Required Technology to Solve It

- **Linux**
- **Git**
- **Git Repository**
- **Bash Terminal**

# 3. How to Solve It

### Step 1

Log in to the **Storage Server** and switch to the root user.

```bash
sudo su -
```

### Step 2

Navigate to the Git repository.

```bash
cd /usr/src/kodekloudrepos/ecommerce
```

### Step 3

Verify that the repository is accessible.

```bash
git status
```

### Step 4

Ensure you are currently on the **master** branch.

```bash
git checkout master
```

### Step 5

Create the required Git branch.

```bash
git branch xfusioncorp_ecommerce
```

### Step 6

Verify that the new branch has been created successfully.

```bash
git branch
```

Expected output:

```text
* master
  xfusioncorp_ecommerce
```

# 4. Main Takeaways

- Learned how to create a new Git branch from an existing branch
- Understood that creating a branch does not modify project files
- Practiced using Git commands from the Linux terminal
- Verified branch creation without affecting the master branch
- Reinforced the importance of branching for isolated feature development

# 5. Conclusion

This task demonstrates one of Git's core workflows: creating a new branch from the **master** branch for future development. Branches allow developers to work independently without impacting the main codebase, making collaboration safer and more organized. Since no code changes were required, the repository remains unchanged except for the addition of the new branch.
