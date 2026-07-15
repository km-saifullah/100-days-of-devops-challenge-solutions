# Create, Review, and Merge a Pull Request in Gitea

## 1. What is the Challenge?

The objective is to follow a proper **Git collaboration workflow** using **Gitea** instead of pushing changes directly to the **master** branch.

Developer **Max** has already pushed his work to a feature branch:

```text
story/fox-and-grapes
```

Your task is to create a **Pull Request (PR)** from this branch into **master**, assign **Tom** as the reviewer, and then log in as **Tom** to review, approve, and merge the Pull Request.

# 2. Required Technology to Solve It

- Linux
- Git
- Gitea
- Git Branches
- Pull Requests (PR)
- Code Review Workflow
- Web Browser

# 3. How to Solve It

### Step 1

SSH into the **Storage Server** using **max**.

```bash
ssh max@ststor01
```

Password:

```text
Max_pass123
```

### Step 2

Navigate to Max's cloned repository.

Example:

```bash
cd ~
```

or

```bash
cd <repository-name>
```

### Step 3

Verify the repository contents.

View commit history.

```bash
git log --oneline --decorate --graph
```

Or view detailed history.

```bash
git log
```

Confirm:

- Sarah's commits exist
- Max's story exists
- Commit authors are correct

### Step 4

Open the **Gitea UI** using the **Gitea** button available in the KodeKloud lab.

### Step 5

Login as **max**.

```text
Username: max
Password: Max_pass123
```

### Step 6

Open the repository.

Select:

```text
New Pull Request
```

### Step 7

Configure the Pull Request.

Title:

```text
Added fox-and-grapes story
```

Source Branch:

```text
story/fox-and-grapes
```

Destination Branch:

```text
master
```

Click:

```text
Create Pull Request
```

### Step 8

Assign **Tom** as Reviewer.

Inside the Pull Request:

- Click **Reviewers**
- Select:

```text
tom
```

Save the reviewer assignment.

### Step 9

Logout from Gitea.

### Step 10

Login as **tom**.

```text
Username: tom
Password: Tom_pass123
```

### Step 11

Open the Pull Request.

Locate:

```text
Added fox-and-grapes story
```

Review the code.

### Step 12

Approve the Pull Request.

Click:

```text
Approve
```

### Step 13

Merge the Pull Request.

Click:

```text
Merge Pull Request
```

Confirm the merge.

### Step 14

Verify that the Pull Request has been merged successfully.

### Step 15

(Optional)

Take screenshots of:

- Pull Request creation
- Reviewer assignment
- Approval
- Successful merge

These screenshots can be submitted if the task requires review.

# 4. Main Takeaways

- Learned why developers should avoid pushing directly to the **master** branch
- Created a Pull Request using Gitea
- Assigned a reviewer before merging
- Reviewed code as another user
- Approved and merged a Pull Request following a real DevOps workflow
- Understood the complete Git collaboration lifecycle used in production environments

# 5. Conclusion

This task demonstrates a standard Git collaboration workflow using **feature branches**, **Pull Requests**, and **code reviews**. By requiring a reviewer before merging into the **master** branch, teams ensure that only reviewed and approved code reaches production, improving code quality and reducing deployment risks.
