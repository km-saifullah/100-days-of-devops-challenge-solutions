# Jenkins Parameterized Job

## 1. Objective

Create a simple parameterized Jenkins job that accepts a stage and environment as parameters and displays their values during the build.

## 2. Login to Jenkins

Click the **Jenkins** button on the top bar.

Login using

```text
Username: admin
Password: Adm!n321
```

## 3. Create Jenkins Job

From the Jenkins dashboard, select

```text
New Item
```

Enter the job name

```text
parameterized-job
```

Select

```text
Freestyle project
```

Click

```text
OK
```

## 4. Create Stage Parameter

Enable

```text
This project is parameterized
```

Select

```text
Add Parameter → String Parameter
```

Configure

```text
Name: Stage
Default Value: Build
```

## 5. Create Environment Choice Parameter

Select

```text
Add Parameter → Choice Parameter
```

Configure

```text
Name: env
```

Add the following choices

```text
Development
Staging
Production
```

Each choice should be entered on a separate line.

## 6. Configure Shell Command

Go to

```text
Build Steps → Add build step → Execute shell
```

Add

```bash
echo "Stage: $Stage"
echo "Environment: $env"
```

This prints both parameter values during the Jenkins build.

## 7. Save the Job

Click

```text
Save
```

The job should now be available as

```text
parameterized-job
```

## 8. Build with Parameters

Open

```text
parameterized-job
```

Click

```text
Build with Parameters
```

Use

```text
Stage: Build
Environment: Production
```

Click

```text
Build
```

## 9. Verify the Build

Open the build and select

```text
Console Output
```

The output should contain

```text
Stage: Build
Environment: Production
```

The build should finish with

```text
Finished: SUCCESS
```

## 10. Final Verification

- Job name is `parameterized-job`
- `Stage` is a String Parameter
- `Stage` default value is `Build`
- `env` is a Choice Parameter
- `env` contains `Development`, `Staging`, and `Production`
- The shell command prints both parameter values
- The job was successfully built with `Production`
- The build completed successfully

## Conclusion

The `parameterized-job` Jenkins job was successfully created and configured with the required parameters. The job was tested using the `Production` environment and the build completed successfully.
