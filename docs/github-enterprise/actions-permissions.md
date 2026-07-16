# GitHub Actions Permissions

## Purpose

GitHub Actions workflows should run with the minimum permissions required.

This follows the principle of least privilege.

In production CI/CD systems, workflows should not automatically receive broad write access unless the job truly needs it.

---

## Why Permissions Matter

GitHub Actions can access the repository through the `GITHUB_TOKEN`.

If permissions are too broad, a compromised workflow could potentially:

```text
Modify repository contents
Create or update pull requests
Push code
Upload or modify security results
Access packages
Trigger deployments
```

So every workflow should define only the permissions it needs.

---

## Default Risk

If workflow permissions are not explicitly controlled, teams may accidentally allow more access than needed.

Bad example:

```yaml
permissions: write-all
```

This is risky because it gives broad write access.

---

## Better Approach

Use explicit permissions.

Example for read-only scanning:

```yaml
permissions:
  contents: read
```

Example for SARIF/security upload:

```yaml
permissions:
  contents: read
  security-events: write
```

Example for pull request comments:

```yaml
permissions:
  contents: read
  pull-requests: write
```

---

## Current Repository Usage

This repository uses security workflows such as:

```text
Gitleaks
Trivy
Semgrep
kube-score
```

Most scanning jobs should only need:

```yaml
permissions:
  contents: read
```

Some security reporting workflows may need:

```yaml
permissions:
  security-events: write
```

---

## Recommended Permission Model

| Workflow Type | Recommended Permission |
|---|---|
| Documentation checks | `contents: read` |
| Secret scanning | `contents: read` |
| SAST scanning | `contents: read` |
| Container scanning | `contents: read` |
| Kubernetes YAML scanning | `contents: read` |
| SARIF upload | `contents: read`, `security-events: write` |
| PR comment bot | `contents: read`, `pull-requests: write` |
| Package publish | `contents: read`, `packages: write` |
| Deployment workflow | `contents: read`, environment-specific secrets |

---

## Repository-Level Recommendation

In GitHub repository settings:

```text
Repository
  -> Settings
  -> Actions
  -> General
  -> Workflow permissions
```

Recommended setting:

```text
Read repository contents permission
```

Then add extra permissions only inside workflows that need them.

---

## Enterprise Explanation

In GitHub Enterprise, Actions permissions are usually controlled at organization and repository level.

Security teams often restrict default token permissions and allow workflow-specific permissions only when required.

This reduces the blast radius if a workflow, dependency, or third-party action is compromised.

---

## Interview Answer

GitHub Actions permissions control what the workflow token can do inside a repository.

In production, I would avoid broad permissions like `write-all`. I would set default workflow permissions to read-only and then grant specific permissions per workflow, such as `security-events: write` only when uploading SARIF results.

This follows least privilege and reduces the risk of CI/CD pipeline compromise.