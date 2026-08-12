# Create Kubernetes Pod with Environment Variables

## 1. What is the Challenge?

The objective is to create a Kubernetes Pod that prints a greeting using environment variables.

The Pod must be named:

```text
print-envars-greeting
```

The container must be named:

```text
print-env-container
```

The container must use the:

```text
bash
```

image.

The Pod must define three environment variables:

```text
GREETING = Welcome to
COMPANY  = DevOps
GROUP    = Group
```

The container must execute the exact command:

```text
["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
```

The Pod must use:

```text
restartPolicy: Never
```

The expected output is:

```text
Welcome to DevOps Group
```

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Bash Docker Image
- Environment Variables
- Kubernetes Pod

# 3. How to Solve It

### Step 1

Create the Kubernetes YAML file:

```bash
vi print-envars-greeting.yaml
```

Add:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  restartPolicy: Never
  containers:
    - name: print-env-container
      image: bash
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "DevOps"
        - name: GROUP
          value: "Group"
      command:
        - /bin/sh
        - -c
        - 'echo "$(GREETING) $(COMPANY) $(GROUP)"'
```

### Step 2

Create the Pod:

```bash
kubectl apply -f print-envars-greeting.yaml
```

Expected:

```text
pod/print-envars-greeting created
```

### Step 3

Check the Pod status:

```bash
kubectl get pod print-envars-greeting
```

Since the command runs once and finishes, the Pod should eventually show:

```text
Completed
```

### Step 4

Check the application output:

```bash
kubectl logs -f print-envars-greeting
```

Expected:

```text
Welcome to DevOps Group
```

### Step 5

Verify the exact container name:

```bash
kubectl get pod print-envars-greeting \
  -o jsonpath='{.spec.containers[*].name}{"\n"}'
```

Expected:

```text
print-env-container
```

### Step 6

Verify the image:

```bash
kubectl get pod print-envars-greeting \
  -o jsonpath='{.spec.containers[*].image}{"\n"}'
```

Expected:

```text
bash
```

### Step 7

Verify the environment variables:

```bash
kubectl describe pod print-envars-greeting
```

You should find:

```text
GREETING: Welcome to
COMPANY:  DevOps
GROUP:    Group
```

# 4. Main Takeaways

- Learned how to create a Kubernetes Pod using YAML
- Learned how to define environment variables inside a container
- Used the exact required container name
- Used the exact required command
- Used `restartPolicy: Never` so the completed container does not restart
- Used `kubectl logs` to verify the application's output

# 5. Conclusion

The final Kubernetes Pod contains:

```text
Pod:
print-envars-greeting
```

```text
Container:
print-env-container
```

```text
Image:
bash
```

```text
Environment Variables:

GREETING = Welcome to
COMPANY  = DevOps
GROUP    = Group
```

```text
Restart Policy:
Never
```

The container executes:

```text
echo "$(GREETING) $(COMPANY) $(GROUP)"
```

and produces:

```text
Welcome to DevOps Group
```
