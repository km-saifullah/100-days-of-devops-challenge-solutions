# Create a Bare Git Repository on the Storage Server

## 1. What is the Challenge?

The objective is to prepare the **Storage Server** for the Nautilus development team by installing **Git** and creating a **bare Git repository** named **/opt/official.git**. This repository will serve as a centralized remote repository for developers.

# 2. Required Technology to Solve It

- **Linux**
- **Git**
- **YUM Package Manager**
- **Bash**

# 3. How to Solve It

### Step 1

Connect to the **Storage Server** and switch to the root user.

### Step 2

Install Git using the YUM package manager.

### Step 3

Create the bare Git repository:

```text
/opt/official.git
```

### Step 4

Verify that the repository has been created successfully by checking its directory and contents.

# 4. Main Takeaways

- Learned how to install Git using the YUM package manager
- Created a centralized **bare Git repository**
- Understood the difference between a bare repository and a regular repository
- Verified the repository using standard Git commands

# 5. Conclusion

This task demonstrates how to prepare a Linux server as a centralized Git repository by installing Git and creating a bare repository. Bare repositories are commonly used as remote repositories because they do not contain a working directory, making them ideal for collaboration among multiple developers.
