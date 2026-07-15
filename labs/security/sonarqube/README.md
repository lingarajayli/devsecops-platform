# SonarQube Community Edition Lab

![SonarQube](https://img.shields.io/badge/SonarQube-Code%20Quality-blue)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Security%20Analysis-red)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Kind-326CE5?logo=kubernetes&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to run SonarQube Community Edition locally inside a Kind Kubernetes cluster and use it to scan a Python application.

The goal is to understand:

```text
How SonarQube is deployed on Kubernetes
How a Service exposes SonarQube locally
How SonarScanner sends code analysis to SonarQube
How SonarQube detects security issues
How to fix and re-scan code
How Quality Gates are used in DevSecOps workflows
```

---

## What is SonarQube?

SonarQube is a code quality and security analysis platform.

It is commonly used to detect:

```text
Bugs
Code smells
Vulnerabilities
Security hotspots
Duplications
Maintainability issues
Reliability issues
```

---

## SonarQube vs Semgrep

| Tool | Main Purpose |
|---|---|
| Semgrep | SAST security pattern scanning |
| SonarQube | Code quality, bugs, smells, vulnerabilities, and security hotspots |
| Trivy | Container, dependency, filesystem, IaC, and Kubernetes scanning |
| Gitleaks | Secret scanning |

SonarQube is often used in CI/CD pipelines to enforce Quality Gates before code is merged or deployed.

---

## Lab Structure

```text
labs/security/sonarqube/
├── README.md
├── docker-compose.yml
├── kubernetes/
│   ├── deployment.yaml
│   ├── namespace.yaml
│   ├── pvc.yaml
│   └── service.yaml
├── reports/
│   └── comparison-summary.md
└── sample-python-app/
    ├── app.py
    ├── app-fixed.py
    └── sonar-project.properties
```

---

## Deployment Method

This lab uses Kubernetes as the primary deployment method.

```text
Preferred deployment: Kind Kubernetes cluster
Fallback deployment: Docker Compose
```

The Docker Compose file is kept only as an optional fallback for local testing.

---

## Kubernetes Resources

| File | Purpose |
|---|---|
| `kubernetes/namespace.yaml` | Creates a dedicated `sonarqube` namespace |
| `kubernetes/pvc.yaml` | Creates persistent storage for SonarQube data |
| `kubernetes/deployment.yaml` | Runs SonarQube Community Edition |
| `kubernetes/service.yaml` | Exposes SonarQube using NodePort |

---

## Deploy SonarQube on Kind

Apply the Kubernetes manifests:

```bash
kubectl apply -f labs/security/sonarqube/kubernetes/
```

If the namespace is not ready during the first apply, apply the deployment again:

```bash
kubectl apply -f labs/security/sonarqube/kubernetes/deployment.yaml
```

Check resources:

```bash
kubectl get all -n sonarqube
kubectl get pvc -n sonarqube
```

Watch the Pod:

```bash
kubectl get pods -n sonarqube -w
```

---

## Access SonarQube

The Kubernetes Service exposes SonarQube using NodePort:

```text
http://localhost:30900
```

If NodePort access does not work in Kind, use port-forward:

```bash
kubectl port-forward -n sonarqube service/sonarqube 9000:9000
```

Then open:

```text
http://localhost:9000
```

Default first login:

```text
Username: admin
Password: admin
```

SonarQube asks to change the password after first login.

---

## SonarScanner CLI

SonarScanner CLI was installed locally in WSL.

Verify:

```bash
sonar-scanner --version
```

Example version used:

```text
SonarScanner CLI 7.2.0.5079
```

---

## Sample Python App

The lab uses two files:

| File | Purpose |
|---|---|
| `sample-python-app/app.py` | Vulnerable example with hardcoded credential |
| `sample-python-app/app-fixed.py` | Fixed example using environment variable |

---

## Vulnerable Pattern

The vulnerable file contains a hardcoded password-like value:

```python
password = "admin123"
```

SonarQube detected this as a security issue.

---

## Fixed Pattern

The fixed file reads the value from an environment variable:

```python
import os

def get_application_password():
    return os.getenv("APP_PASSWORD", "password-not-configured")
```

This avoids storing the secret directly in source code.

---

## sonar-project.properties

The project configuration uses the fixed file for the after-fix scan:

```properties
sonar.projectKey=sample-python-app
sonar.projectName=sample-python-app
sonar.projectVersion=1.0

sonar.sources=app-fixed.py
sonar.sourceEncoding=UTF-8
```

---

## Run SonarQube Scan

Export the token locally:

```bash
export SONAR_TOKEN="YOUR_TOKEN_HERE"
```

Do not commit the token.

Run scanner:

```bash
cd labs/security/sonarqube/sample-python-app

sonar-scanner \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token="$SONAR_TOKEN"
```

---

## Scan Result

```text
Before fix: 1 security issue
After fix: 0 new issues
Quality Gate: Passed
```

---

## Secret Handling Lesson

During this lab, a SonarQube token was accidentally exposed in chat and was immediately rotated.

Important rule:

```text
Any token exposed in chat, logs, screenshots, GitHub, Slack, or email should be treated as compromised and rotated immediately.
```

---

## Production Secret Storage

| Use Case | Recommended Secret Store |
|---|---|
| GitHub Actions pipeline secret | GitHub Actions Secrets |
| Kubernetes runtime secret | Kubernetes Secret or External Secrets |
| Central production secrets | HashiCorp Vault or cloud secret manager |
| Local temporary testing | Environment variable |

---

## Production Usage

In production, SonarQube is commonly integrated into:

```text
GitHub Actions
GitLab CI/CD
Jenkins
Pull request checks
Quality Gate enforcement
Release pipelines
```

A common policy is:

```text
Fail pipeline if Quality Gate fails
Block merge if critical security issues exist
Review security hotspots before approval
Track code quality trends over time
Rotate exposed tokens immediately
```

---

## Troubleshooting Commands

```bash
kubectl get all -n sonarqube
kubectl get pvc -n sonarqube
kubectl describe pod -n sonarqube -l app=sonarqube
kubectl logs -n sonarqube deployment/sonarqube --tail=100
kubectl get events -n sonarqube --sort-by=.lastTimestamp
```

---

## Interview Explanation

SonarQube is a code quality and security analysis platform used to detect bugs, code smells, vulnerabilities, and security hotspots.

In this lab, I deployed SonarQube Community Edition inside a local Kind Kubernetes cluster using Kubernetes manifests.

I exposed SonarQube using a Kubernetes Service, accessed it locally using port-forward, created a Python project, generated a token, and scanned the code using SonarScanner CLI.

SonarQube detected a medium security issue caused by a hardcoded password-like value.

I kept the vulnerable file for learning, created a fixed version that reads the value from an environment variable, re-ran the scan, and confirmed that the project had 0 new issues and the Quality Gate passed.

This demonstrates how SonarQube can be integrated into a DevSecOps workflow to improve code quality and catch security issues before production.

---

## Lab Status

```text
Tool: SonarQube Community Edition
Deployment: Kind Kubernetes cluster
Scanner: SonarScanner CLI
Scan type: Code quality and security analysis
Before-fix result: 1 security issue
After-fix result: 0 new issues
Quality Gate: Passed
Status: Completed
```