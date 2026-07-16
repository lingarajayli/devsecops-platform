# Required Status Checks

## Purpose

Required status checks ensure that important CI/CD workflows pass before code is merged into `main`.

In production teams, required checks help prevent broken, insecure, or unvalidated changes from reaching stable branches.

---

## What Are Status Checks?

Status checks are results reported by GitHub Actions or external CI/CD systems.

Examples:

```text
Build passed
Tests passed
Security scan passed
Container scan passed
Kubernetes manifest scan passed
```

When branch protection requires these checks, GitHub blocks the merge until all required checks pass.

---

## Recommended Required Checks for This Repository

This repository includes multiple DevSecOps workflows.

Recommended required checks for `main`:

```text
Gitleaks Secret Scan
Trivy Image Scan
Trivy Critical Gate
Semgrep SAST Scan
Semgrep SAST Gate
Trivy Kubernetes Config Scan
kube-score Kubernetes Scan
```

---

## Why These Checks Matter

| Check | Why It Matters |
|---|---|
| Gitleaks Secret Scan | Prevents hardcoded secrets from entering the repository |
| Trivy Image Scan | Detects vulnerable container packages |
| Trivy Critical Gate | Blocks critical container vulnerabilities |
| Semgrep SAST Scan | Detects insecure source code patterns |
| Semgrep SAST Gate | Blocks serious insecure code findings |
| Trivy Kubernetes Config Scan | Blocks HIGH/CRITICAL Kubernetes misconfigurations |
| kube-score Kubernetes Scan | Enforces production-readiness expectations |

---

## Recommended GitHub Settings

Go to:

```text
Repository
  -> Settings
  -> Branches
  -> Branch protection rules
  -> main
```

Enable:

```text
Require status checks to pass before merging
Require branches to be up to date before merging
```

Then select the required GitHub Actions checks.

---

## Important Design Decision

This repository intentionally contains vulnerable examples for learning.

So CI/CD gates should scan fixed or deployable artifacts, not every training file.

```text
Vulnerable files = learning evidence
Fixed files      = deployable evidence
CI/CD gates      = production-style validation
```

---

## Enterprise Explanation

In GitHub Enterprise, required checks are used to enforce engineering quality and security standards.

A pull request cannot be merged until the configured workflows pass. This gives teams confidence that every change has passed automated validation before entering the protected branch.

---

## Interview Answer

Required status checks are CI/CD checks that must pass before a pull request can be merged.

In a production GitHub Enterprise setup, I would require checks such as secret scanning, SAST, container scanning, Kubernetes manifest scanning, tests, and build validation.

This prevents insecure or broken changes from entering `main` and creates an auditable quality gate for every change.