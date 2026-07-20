# Flask Health API

## Purpose

This is a small Flask-based API built for a real DevOps and DevSecOps CI/CD pipeline project.

The goal is to demonstrate:

```text
Python API basics
Unit testing with pytest
Docker containerization
Kubernetes deployment
Health checks
Service routing
CI/CD pipeline readiness
```

---

## Application Endpoints

| Endpoint | Purpose | Expected Response |
|---|---|---|
| `/` | Application information | Service name and running status |
| `/health` | Health check endpoint | Healthy status |

Example:

```bash
curl http://localhost:5000/
```

Expected output:

```json
{
  "message": "DevSecOps CI/CD pipeline demo app",
  "service": "flask-health-api",
  "status": "running"
}
```

Health endpoint:

```bash
curl http://localhost:5000/health
```

Expected output:

```json
{
  "status": "healthy"
}
```

---

## Project Structure

```text
apps/flask-health-api/
├── app.py
├── test_app.py
├── requirements.txt
├── Dockerfile
├── README.md
└── kubernetes/
    ├── namespace.yml
    ├── deployment.yml
    └── service.yml
```

---

## Run Unit Tests Locally

Create and activate a Python virtual environment:

```bash
cd apps/flask-health-api

python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run tests:

```bash
pytest -v
```

Expected result:

```text
2 passed
```

---

## Run Application Locally

```bash
cd apps/flask-health-api

source .venv/bin/activate

python app.py
```

Test from another terminal:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

---

## Build Docker Image

```bash
cd apps/flask-health-api

docker build -t flask-health-api:local .
```

Run container:

```bash
docker run --rm -p 5000:5000 flask-health-api:local
```

Test:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

---

## Deploy to Kind Kubernetes Cluster

Create namespace:

```bash
kubectl apply -f apps/flask-health-api/kubernetes/namespace.yml
```

Load local Docker image into Kind:

```bash
kind load docker-image flask-health-api:local --name devsecops-lab
```

Apply Deployment:

```bash
kubectl apply -f apps/flask-health-api/kubernetes/deployment.yml
```

Apply Service:

```bash
kubectl apply -f apps/flask-health-api/kubernetes/service.yml
```

Verify resources:

```bash
kubectl get all -n flask-health-api
kubectl get endpoints -n flask-health-api
```

---

## Access Through Kubernetes Service

Use port-forward:

```bash
kubectl port-forward -n flask-health-api service/flask-health-api 5000:5000
```

Test:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

---

## Kubernetes Features Used

| Feature | Purpose |
|---|---|
| Namespace | Isolates the app resources |
| Deployment | Runs and manages the Flask API Pod |
| Service | Provides stable internal access to the Pod |
| Labels | Organizes and selects Kubernetes resources |
| Readiness Probe | Checks if app is ready to receive traffic |
| Liveness Probe | Checks if app should be restarted |
| Resource Requests/Limits | Controls CPU and memory usage |
| Security Context | Reduces container privileges |

---

## Troubleshooting Notes

### ImagePullBackOff

Issue:

```text
Pod status: ImagePullBackOff
```

Reason:

```text
Kind cluster could not find the local Docker image.
```

Fix:

```bash
kind load docker-image flask-health-api:local --name devsecops-lab

kubectl delete pod -n flask-health-api -l app.kubernetes.io/name=flask-health-api
```

---

### Service Has No Endpoint

Check:

```bash
kubectl get endpoints -n flask-health-api
```

If endpoint is empty, check whether the Service selector matches the Pod labels.

```bash
kubectl get pods -n flask-health-api --show-labels
kubectl describe svc flask-health-api -n flask-health-api
```

---

## DevOps Interview Explanation

This project demonstrates a simple end-to-end application delivery flow.

I created a small Flask API with a `/health` endpoint, added pytest unit tests, containerized it using Docker, and deployed it into a local Kind Kubernetes cluster.

The Kubernetes deployment includes production-style labels, resource requests and limits, readiness and liveness probes, and a ClusterIP Service.

I also tested the full flow from local app execution to Docker container execution and then Kubernetes Service access using port-forwarding.

This proves practical understanding of application packaging, containerization, Kubernetes workloads, health checks, and deployment troubleshooting.

---

## Current Status

```text
Flask app: Completed
Unit tests: Completed
Dockerfile: Completed
Docker build: Tested
Kubernetes namespace: Completed
Kubernetes deployment: Completed
Kubernetes service: Completed
Service access: Tested
```