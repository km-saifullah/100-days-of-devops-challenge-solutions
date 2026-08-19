# Fix Python Flask Application on Kubernetes

## 1. What is the Challenge?

The objective is to fix an existing Python Flask application deployed on the Kubernetes cluster.

The Deployment and Service were already created, but the application was not coming up because there were configuration issues with the Deployment image and Service port.

The application must be accessible through NodePort `32345`.

# 2. Required Technology to Solve It

- Kubernetes
- kubectl
- Deployment
- NodePort Service
- Python Flask

# 3. Identify the Issues

Check the Deployment:

```bash
kubectl get deployment python-deployment-nautilus -o yaml
```

The Deployment was using

```yaml
image: poroko/flask-app-demo
```

But the required image is

```yaml
image: poroko/flask-demo-app
```

The Service was also configured with

```text
TargetPort: 8080
```

But the Flask application listens on

```text
5000
```

The NodePort `32345` was already correct.

# 4. Fix the Deployment

Update the container image

```bash
kubectl set image deployment/python-deployment-nautilus \
  python-container-nautilus=poroko/flask-demo-app
```

Verify

```bash
kubectl get deployment python-deployment-nautilus \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Expected Output

```text
poroko/flask-demo-app
```

# 5. Fix the Service

Edit the Service

```bash
kubectl edit svc python-service-nautilus
```

Configure the port as

```yaml
ports:
  - port: 5000
    targetPort: 5000
    nodePort: 32345
    protocol: TCP
```

The important values are

```text
targetPort: 5000
nodePort: 32345
```

Alternatively, the Service can be fixed directly with:

```bash
kubectl patch svc python-service-nautilus \
  -p '{"spec":{"ports":[{"port":5000,"targetPort":5000,"nodePort":32345,"protocol":"TCP"}]}}'
```

# 6. Verify the Deployment

Check the Pods

```bash
kubectl get pods
```

The new Pod should eventually be

```text
1/1   Running
```

Check the Deployment

```bash
kubectl get deployment python-deployment-nautilus
```

Expected Output

```text
READY   UP-TO-DATE   AVAILABLE
1/1     1            1
```

# 7. Verify the Service

Run:

```bash
kubectl get svc python-service-nautilus
```

The Service should show

```text
5000:32345/TCP
```

Check the endpoints

```bash
kubectl get endpoints python-service-nautilus
```

An endpoint should now be available on port `5000`.

# 8. Test the Application

Get the node IP

```bash
kubectl get nodes -o wide
```

Then test the Flask application

```bash
curl http://<NODE-IP>:32345
```

# 9. Main Takeaways

- Always verify the container image name when a Pod fails to start
- The required image was `poroko/flask-demo-app`
- The Flask application listens on port `5000`
- The Service `targetPort` must point to port `5000`
- The required NodePort is `32345`
- The Service selector must match the Pod label `app=python_app`
- Empty Service endpoints usually indicate that the Service is not currently selecting a ready Pod

# 10. Conclusion

The Python Flask application was not coming up because the Deployment was using an incorrect image name and the Service was targeting the wrong application port.

The Deployment was updated to use `poroko/flask-demo-app`, while the Service was configured to forward traffic to port `5000` through NodePort `32345`.

After verifying the Pod, Service, and endpoints, the application can be accessed through the specified NodePort.
