# Branch Protection Rules

## Purpose

Branch protection prevents unsafe or unreviewed changes from being merged into important branches like `main`.

In production teams, `main` usually represents stable code. Direct pushes to `main` are restricted, and changes must go through pull requests.

---

## Recommended Protection for `main`

For this repository, the recommended `main` branch protection rules are:

```text
Require a pull request before merging
Require approvals
Require review from CODEOWNERS
Require status checks to pass
Require branches to be up to date before merging
Require conversation resolution before merging
Restrict force pushes
Restrict branch deletion
```

---

## Why Direct Pushes Are Risky

Direct pushes to `main` can cause:

```text
Broken builds
Security issues reaching main
Unreviewed production changes
Missing audit trail
Accidental secret commits
Loss of rollback visibility
```

---

## Recommended GitHub Settings

Go to:

```text
Repository
  -> Settings
  -> Branches
  -> Branch protection rules
  -> Add rule
```

Branch name pattern:

```text
main
```

Enable:

```text
Require a pull request before merging
Require approvals: 1
Require review from Code Owners
Require status checks to pass before merging
Require branches to be up to date before merging
Require conversation resolution before merging
Do not allow bypassing the above settings
Restrict force pushes
Restrict deletions
```

---

## Required Status Checks

Recommended required checks:

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

## Enterprise Explanation

In GitHub Enterprise, branch protection is used to enforce safe engineering workflow.

A developer creates a feature branch, opens a pull request, CI/CD checks run automatically, reviewers approve the change, and only then the change is merged into `main`.

This gives the team:

```text
Quality control
Security control
Review history
Auditability
Rollback visibility
Compliance evidence
```

---

## Interview Answer

Branch protection helps prevent direct and unsafe changes to important branches like `main`.

In a production GitHub Enterprise setup, I would enable pull request-based merges, required approvals, CODEOWNER review, required CI/CD checks, conversation resolution, and protection against force pushes or branch deletion.

This ensures that every change is reviewed, tested, traceable, and compliant with the team's engineering standards.