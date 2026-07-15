# SonarQube Scan Comparison

## Files Compared

| File | Purpose | Result |
|---|---|---|
| `sample-python-app/app.py` | Vulnerable example | 1 security issue |
| `sample-python-app/app-fixed.py` | Fixed example | 0 new issues |

---

## Issue Detected

| Category | Issue | Severity |
|---|---|---|
| Security | Potential hardcoded credential | Medium |

---

## Vulnerable Pattern

The vulnerable file contained a hardcoded password-like value:

```python
password = "admin123"
```

This is risky because secrets should never be stored directly in source code.

Hardcoded credentials can leak through:

```text
Git history
GitHub repositories
CI/CD logs
Docker images
Backups
Shared screenshots
Developer machines
```

---

## Fixed Pattern

The fixed file reads the value from an environment variable instead of hardcoding it:

```python
import os

def get_application_password():
    return os.getenv("APP_PASSWORD", "password-not-configured")
```

This is safer because the secret value is not stored in the source code.

---

## Key Result

```text
Before fix: 1 security issue
After fix: 0 new issues
Quality Gate: Passed
```

---

## Lesson Learned

SonarQube helps detect code quality and security issues during development.

In this lab, SonarQube detected a hardcoded credential pattern in a Python application.

The issue was fixed by moving the sensitive value out of source code and reading it from an environment variable.

---

## Production Remediation Strategy

```text
1. Do not hardcode secrets in source code
2. Store secrets in a secure secret manager
3. Use environment variables or runtime secret injection
4. Rotate exposed credentials immediately
5. Add automated scanning in CI/CD
6. Fail builds for critical security issues
7. Review SonarQube findings before merge
```

---

## Where Secrets Should Be Stored

| Use Case | Recommended Secret Store |
|---|---|
| GitHub Actions pipeline secret | GitHub Actions Secrets |
| Kubernetes runtime secret | Kubernetes Secret |
| Production secret management | HashiCorp Vault or cloud secret manager |
| Local temporary testing | Environment variable |

---

## Interview Explanation

SonarQube is used to analyze code quality, bugs, vulnerabilities, code smells, and security hotspots.

In this lab, I deployed SonarQube Community Edition inside a local Kind Kubernetes cluster.

I scanned a Python application and SonarQube detected a medium security issue caused by a hardcoded password-like value.

I kept the vulnerable file for learning, created a fixed file, moved the secret handling to an environment variable, and re-ran the scan.

After the fix, the project showed 0 new issues and the Quality Gate passed.

This demonstrates how SonarQube can be used in a DevSecOps workflow to catch security and quality issues before code reaches production.

---

## Lab Status

```text
Tool: SonarQube Community Edition
Deployment: Kind Kubernetes cluster
Scan type: Code quality and security analysis
Before-fix result: 1 security issue
After-fix result: 0 new issues
Quality Gate: Passed
Status: Completed
```