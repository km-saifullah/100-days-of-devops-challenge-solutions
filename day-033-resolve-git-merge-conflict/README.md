# Resolve Git Push Conflict and Update Story Index

## 1. What is the Challenge?

The goal is to fix Max's Git push issue by syncing the local repository with the remote repository, updating the `story-index.txt` file, correcting the typo **Mooose → Mouse**, and then pushing the changes successfully.

# 2. Required Technology to Solve It

- Linux
- Git
- Gitea

### Repository

```text
/home/max/story-blog
```

### Login

```text
Username: max
Password: Max_pass123
```

# 3. How to Solve It

### Step 1

SSH into the Storage Server as **max**.

```bash
ssh max@ststor01
```

### Step 2

Go to the repository.

```bash
cd ~/story-blog
```

### Step 3

Pull the latest changes.

```bash
git pull origin master
```

### Step 4

If there are merge conflicts, edit the files and remove the conflict markers.

### Step 5

Open `story-index.txt` and:

- Add all **4 story titles**
- Correct:

```text
The Lion and the Mouse
The Frogs and the Ox
The Fox and the Grapes
The Donkey and the Dog
```

### Step 6

Stage and commit the changes.

```bash
git add .

git commit
```

> Note: After the Step-6 you need to save the commit file.

### Step 7

Push the changes.

```bash
git push origin master
```

# 4. Main Takeaways

- Learned how to resolve Git push conflicts
- Pulled the latest changes from the remote repository
- Fixed merge conflicts
- Updated and committed project files
- Successfully pushed the changes

# 5. Conclusion

This task demonstrates a common Git collaboration workflow. By pulling the latest changes, resolving conflicts, updating the required files, and pushing the final commit, the local and remote repositories remain synchronized.
