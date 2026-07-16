# GitHub Environments and Deployment Approvals

## Purpose

GitHub Environments are used to control deployments to different stages such as `dev`, `stage`, and `prod`.

They help teams add approval gates, environment-specific secrets, and deployment history.

---

## Why Environments Matter

In production teams, not every workflow should deploy directly to production.

A safer deployment flow is:

```text
Code merged
     |
     v
CI checks pass
     |
     v
Deploy to dev
     |
     v
Deploy to stage
     |
     v
Manual approval
     |
     v
Deploy to prod
```

---

## Common Environment Names

Typical GitHub environments:

```text
dev
stage
prod
```

Each environment can have different:

```text
Secrets
Variables
Approval rules
Deployment history
Access controls
```

---

## Environment Secrets

Environment secrets are only available to workflows that target that environment.

Example:

| Environment | Secret Example |
|---|---|
| dev | `DEV_DEPLOY_TOKEN` |
| stage | `STAGE_DEPLOY_TOKEN` |
| prod | `PROD_DEPLOY_TOKEN` |

This prevents production secrets from being exposed to every workflow.

---

## Deployment Approval Gates

For production, teams often require manual approval before deployment.

Example:

```text
Developer opens PR
CI/CD checks pass
PR is approved and merged
Deployment workflow starts
Production environment waits for approval
Authorized reviewer approves
Production deployment continues
```

This protects production from accidental or unauthorized deployments.

---

## Example GitHub Actions Usage

```yaml
jobs:
  deploy-prod:
    runs-on: ubuntu-latest
    environment: prod

    steps:
      - name: Deploy to production
        run: echo "Deploying to production"
```

If the `prod` environment has required reviewers configured, GitHub pauses the job until approval is given.

---

## Recommended Repository Simulation

For this repository, the recommended environment setup is:

| Environment | Purpose | Approval |
|---|---|---|
| dev | Local/lab deployment simulation | No approval |
| stage | Pre-production simulation | Optional approval |
| prod | Production deployment simulation | Required approval |

---

## Recommended GitHub Settings

Go to:

```text
Repository
  -> Settings
  -> Environments
  -> New environment
```

Create:

```text
dev
stage
prod
```

For `prod`, enable:

```text
Required reviewers
Deployment branches restricted to main
Environment secrets for production credentials
```

---

## Enterprise Explanation

In GitHub Enterprise, environments are used to separate deployment stages and protect sensitive credentials.

Production environments usually require approvals so that deployments are controlled and auditable.

This gives teams:

```text
Controlled deployments
Environment-specific secrets
Approval history
Deployment audit trail
Reduced production risk
```

---

## Interview Answer

GitHub Environments allow us to define deployment targets such as dev, stage, and prod.

Each environment can have its own secrets, variables, approval rules, and deployment history.

In production, I would use environment protection rules so that prod deployments require approval from authorized reviewers. I would also store production credentials as environment secrets so they are only available during approved production deployment jobs.