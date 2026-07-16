# GitHub Enterprise Interview Notes

## Summary

This repository simulates GitHub Enterprise-style workflows using free GitHub features.

The goal is to demonstrate secure software delivery practices used in real engineering teams.

---

## What I Implemented

| Area | Implementation |
|---|---|
| Repository ownership | `.github/CODEOWNERS` |
| Pull request standards | `.github/pull_request_template.md` |
| Branch protection | Documented recommended `main` protection rules |
| Required checks | Documented required CI/CD security checks |
| Actions permissions | Documented least-privilege workflow permissions |
| Secrets and variables | Documented secret and variable usage |
| Environments | Documented dev, stage, and prod deployment approval model |

---

## Enterprise Workflow

A production GitHub workflow usually looks like this:

```text
Developer creates feature branch
        |
        v
Developer opens pull request
        |
        v
GitHub Actions checks run
        |
        v
Required checks must pass
        |
        v
CODEOWNER / reviewer approval
        |
        v
Merge into protected main branch
        |
        v
Deployment to environment
        |
        v
Production approval if required
```

---

## Key Concepts

### Branch Protection

Branch protection prevents unsafe direct changes to important branches like `main`.

In production, I would enable:

```text
Require pull request before merge
Require approval
Require CODEOWNER review
Require status checks
Require branch up to date
Block force push
Block branch deletion
```

---

### CODEOWNERS

CODEOWNERS defines who is responsible for specific files or directories.

Example:

```text
.github/workflows/ @lingarajayli
labs/security/ @lingarajayli
```

In enterprise teams, branch protection can require CODEOWNER approval before merge.

---

### Required Status Checks

Required checks block merging until CI/CD workflows pass.

For this repository, examples include:

```text
Gitleaks Secret Scan
Trivy Image Scan
Semgrep SAST Scan
Trivy Kubernetes Config Scan
kube-score Kubernetes Scan
```

This helps prevent insecure or broken changes from entering `main`.

---

### GitHub Actions Permissions

GitHub Actions workflows should use least privilege.

Good example:

```yaml
permissions:
  contents: read
```

Avoid:

```yaml
permissions: write-all
```

Only grant write permissions when needed, such as:

```yaml
permissions:
  contents: read
  security-events: write
```

---

### Secrets and Variables

Secrets are for sensitive values.

Examples:

```text
SONAR_TOKEN
AWS_ACCESS_KEY_ID
REGISTRY_PASSWORD
```

Variables are for non-sensitive values.

Examples:

```text
APP_NAME
AWS_REGION
ENVIRONMENT
```

Production secrets should usually be stored as environment secrets and protected by deployment approval gates.

---

### Environments

GitHub Environments separate deployment targets like:

```text
dev
stage
prod
```

For production, I would configure:

```text
Required reviewers
Environment secrets
Deployment branch restrictions
Deployment history
```

This prevents accidental or unauthorized production deployments.

---

## Short Interview Answer

I simulated a GitHub Enterprise-style workflow in my public GitHub repository.

I added CODEOWNERS, a pull request template, and documentation for branch protection, required status checks, GitHub Actions permissions, secrets, variables, and environments.

The main idea is to show how production teams protect the `main` branch, require CI/CD checks, enforce review approvals, use least-privilege workflow permissions, protect secrets, and require manual approval for production deployments.

This demonstrates that I understand GitHub not just as a code hosting tool, but as a secure software delivery platform.

---

## Detailed Interview Answer

In enterprise GitHub setups, developers usually do not push directly to `main`.

They create a feature branch and open a pull request. GitHub Actions workflows run automatically. Required checks such as secret scanning, SAST, container scanning, and Kubernetes manifest scanning must pass.

Then reviewers or CODEOWNERS approve the change. Only after approval and passing checks can the change be merged into the protected `main` branch.

For deployments, GitHub Environments can be used to separate `dev`, `stage`, and `prod`. Production deployments can require manual approval and use environment-specific secrets.

I documented this workflow in my repository to show production-style GitHub Enterprise understanding using free GitHub features.

---

## Common Interview Questions

### Q1. What is branch protection?

Branch protection is a GitHub feature that protects important branches like `main`.

It can require pull requests, approvals, status checks, CODEOWNER review, and can block force pushes or branch deletion.

---

### Q2. What is CODEOWNERS?

CODEOWNERS is a GitHub file that defines who owns specific files or directories.

When branch protection requires CODEOWNER review, GitHub requests approval from the defined owners before merging.

---

### Q3. What are required status checks?

Required status checks are CI/CD checks that must pass before a pull request can be merged.

Examples include build, test, secret scanning, SAST, image scanning, and Kubernetes manifest scanning.

---

### Q4. Why should GitHub Actions permissions be restricted?

Because workflows use `GITHUB_TOKEN`.

If permissions are too broad, a compromised workflow or third-party action could modify code, push changes, or access resources.

Least privilege reduces blast radius.

---

### Q5. What is the difference between GitHub Secrets and Variables?

Secrets are encrypted and used for sensitive values like tokens and passwords.

Variables are used for non-sensitive configuration like region, app name, or environment name.

---

### Q6. Why use GitHub Environments?

GitHub Environments help control deployments to `dev`, `stage`, and `prod`.

They support environment-specific secrets, approval gates, deployment history, and access control.

---

### Q7. How would you protect production deployment?

I would use a `prod` GitHub Environment with:

```text
Required reviewers
Production-only environment secrets
Deployment branch restriction to main
Required CI/CD checks before deployment
Audit trail through deployment history
```

---

## What This Proves

This GitHub Enterprise simulation proves understanding of:

```text
Enterprise GitHub workflow
Branch protection
Pull request governance
CODEOWNER approval
Required status checks
GitHub Actions least privilege
Secrets and variables
Environment approval gates
Auditability
Secure CI/CD process
```