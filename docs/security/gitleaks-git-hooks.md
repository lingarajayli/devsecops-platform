# Gitleaks Git Hooks

## Purpose

This document explains how to install local Git hooks for Gitleaks secret scanning.

These hooks help prevent secrets from being committed or pushed accidentally.

---

## Hooks Included

| Hook | Purpose |
|---|---|
| `pre-commit` | Scans the current working directory before a commit is created |
| `pre-push` | Scans Git history before pushing to remote |

---

## Why Hooks Matter

Manual scans are useful, but developers may forget to run them.

Git hooks automate security checks locally.

```text
Developer writes code
        ↓
git commit
        ↓
pre-commit hook runs Gitleaks
        ↓
commit allowed only if no secrets are found
        ↓
git push
        ↓
pre-push hook scans Git history
```

---

## Install Hooks

From the repository root:

```bash
cp scripts/git-hooks/pre-commit .git/hooks/pre-commit
cp scripts/git-hooks/pre-push .git/hooks/pre-push

chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
```

---

## Test Hooks Manually

Run:

```bash
.git/hooks/pre-commit
```

Expected result:

```text
Running Gitleaks pre-commit scan...
no leaks found
Gitleaks pre-commit scan passed.
```

Run:

```bash
.git/hooks/pre-push
```

Expected result:

```text
Running Gitleaks pre-push Git history scan...
no leaks found
Gitleaks pre-push scan passed.
```

---

## Hook Behavior

### Pre-commit

The pre-commit hook runs:

```bash
gitleaks dir . --redact
```

This checks the current directory before a commit is created.

### Pre-push

The pre-push hook runs:

```bash
gitleaks detect --source . --redact
```

This checks committed Git history before code is pushed.

---

## Important Note

Git does not automatically share `.git/hooks/` files when a repository is cloned.

That is why this repository stores reusable hook scripts under:

```text
scripts/git-hooks/
```

Developers must copy them into `.git/hooks/` manually.

---

## Production Recommendation

For team environments, use local hooks plus CI/CD scanning.

```text
Local Git hooks = early prevention
CI/CD scan      = server-side enforcement
```

A developer can bypass local hooks, but they cannot bypass properly configured CI/CD checks.

---

## Interview Explanation

Git hooks are scripts that run automatically during Git actions such as commit or push.

For DevSecOps, I use `pre-commit` hooks to catch secrets before they enter Git history, and `pre-push` hooks to scan committed history before code reaches the remote repository.

In production, I would combine local hooks with CI/CD-based Gitleaks scans so secret detection is enforced both locally and centrally.