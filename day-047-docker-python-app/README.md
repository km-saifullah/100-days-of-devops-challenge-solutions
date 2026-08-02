# Dockerize and Deploy a Python Application

## 1. What is the Challenge?

The objective is to containerize a Python application and deploy it on **Application Server 3** using Docker.

The requirements are:

- Create a Dockerfile under:

```text
/python_app/Dockerfile
```

- Use any Python base image.
- Install the application's dependencies from:

```text
/python_app/src/requirements.txt
```

- Expose container port **3003**.
- Run the application using:

```text
server.py
```

- Build an image named:

```text
nautilus/python-app
```

- Create a container named:

```text
pythonapp_nautilus
```

- Map host port **8091** to container port **3003**.

# 2. Required Technology to Solve It

- Linux
- Docker
- Dockerfile
- Python
- pip

# 3. How to Solve It

### Step 1

SSH into **Application Server 3**.

```bash
ssh banner@stapp03
```

Switch to the root user.

```bash
sudo su -
```

### Step 2

Navigate to the application directory.

```bash
cd /python_app
```

### Step 3

Create the Dockerfile.

```bash
vi Dockerfile
```

Add the following content:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

EXPOSE 3003

CMD ["python", "server.py"]
```

### Step 4

Build the Docker image.

```bash
docker build -t nautilus/python-app .
```

### Step 5

Create and start the container.

```bash
docker run -d \
  --name pythonapp_nautilus \
  -p 8091:3003 \
  nautilus/python-app
```

### Step 6

Verify the deployment.

Check the image:

```bash
docker images
```

Check the running container:

```bash
docker ps
```

Expected output:

```text
pythonapp_nautilus
```

### Step 7

Test the application.

```bash
curl http://localhost:8091
```

If the application is running correctly, it will return the expected response.

# 4. Main Takeaways

- Learned how to create a Dockerfile for a Python application
- Installed Python dependencies using `requirements.txt`
- Built a custom Docker image
- Created a container from the custom image
- Exposed the application using Docker port mapping
- Verified the deployment using Docker and `curl`

# 5. Conclusion

This task demonstrates how to package a Python application into a Docker image and deploy it as a container. Using a Dockerfile ensures a repeatable build process, while Docker simplifies application deployment through containerization and port mapping.
