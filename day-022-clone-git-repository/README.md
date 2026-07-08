# Clone an Existing Git Repository

## 1. What is the Challenge?

The objective is to clone an existing Git repository from **/opt/games.git** into the **/usr/src/kodekloudrepos** directory on the **Storage Server**. The task must be performed using the **natasha** user without modifying the original repository or changing any existing directory permissions.

# 2. Required Technology to Solve It

- **Linux**
- **Git**
- **Bash**
- **Git Clone**

# 3. How to Solve It

### Step 1

Log in to the **Storage Server** as the **natasha** user.

### Step 2

Create the destination directory if it does not already exist:

```text
/usr/src/kodekloudrepos
```

### Step 3

Clone the repository:

```text
/opt/games.git
```

into:

```text
/usr/src/kodekloudrepos/games
```

### Step 4

Verify that the repository has been cloned successfully using `git status` and `ls`.

# 4. Main Takeaways

- Learned how to clone an existing Git repository
- Understood the difference between a bare repository and a working repository
- Verified the cloned repository using Git commands
- Followed the principle of avoiding unnecessary permission or ownership changes

# 5. Conclusion

This task demonstrates how to clone an existing Git repository into a specified directory while preserving the original repository. Performing the operation as the required user ensures proper ownership and follows best practices for repository management.
