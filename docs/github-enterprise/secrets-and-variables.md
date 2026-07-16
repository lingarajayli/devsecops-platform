# GitHub Secrets and Variables

## Purpose

GitHub Secrets and Variables are used to pass configuration into GitHub Actions workflows.

They help separate sensitive and non-sensitive configuration from source code.

---

## Difference Between Secrets and Variables

| Type | Used For | Sensitive? | Example |
|---|---|---|---|
| Secrets | Passwords, tokens, credentials | Yes | `AWS_ACCESS_KEY_ID`, `SONAR_TOKEN` |
| Variables | Non-sensitive configuration | No | `ENVIRONMENT`, `REGION`, `APP_NAME` |

---

## GitHub Secrets

Secrets are encrypted values stored in GitHub.

They should be used for sensitive data such as:

```text
Cloud credentials
API tokens
Registry passwords
SSH private keys
SonarQube tokens
Webhook tokens
```

Secrets should never be committed into Git.

---

## GitHub Variables

Variables are used for non-sensitive configuration.

Examples:

```text
APP_NAME=devsecops-platform
ENVIRONMENT=dev
AWS_REGION=ap-south-1
DEPLOY_TARGET=kind
```

Variables are useful because they make workflows easier to reuse without hardcoding values.

---

## Secret Scopes

GitHub supports different secret scopes.

| Scope | Use Case |
|---|---|
| Repository secrets | Used by one repository |
| Environment secrets | Used only for a specific environment |
| Organization secrets | Shared across selected repositories |

---

## Environment Secrets

Environment secrets are useful for deployment protection.

Example:

```text
dev environment    -> lower-risk secrets
stage environment  -> staging credentials
prod environment   -> production credentials with approval gate
```

In production, sensitive deployment credentials should usually be stored as environment secrets, not general repository secrets.

---

## Example Workflow Usage

```yaml
env:
  APP_NAME: ${{ vars.APP_NAME }}
  AWS_REGION: ${{ vars.AWS_REGION }}

steps:
  - name: Use secret safely
    run: echo "Using token without printing it"
    env:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

Important rule:

```text
Never print secrets in logs.
Never echo secrets for debugging.
Never store secrets in source code.
```

---

## Recommended Practice

For this repository:

| Item | Recommended Storage |
|---|---|
| App name | Repository variable |
| Lab environment name | Repository variable |
| Cloud region | Repository variable |
| SonarQube token | Repository secret |
| Cloud access keys | Environment secret |
| Production deployment token | Production environment secret |

---

## Common Mistakes

Avoid:

```text
Committing .env files
Printing secrets in workflow logs
Using repository secrets for production without environment approval
Reusing the same secret across dev and prod
Giving every workflow access to every secret
Keeping old unused secrets
```

---

## GitHub Enterprise Explanation

In GitHub Enterprise, secrets and variables are controlled at repository, organization, and environment levels.

Security teams usually prefer environment secrets for production deployments because they can be combined with environment approval rules.

This gives better control over who can deploy and when sensitive credentials are exposed to a workflow.

---

## Interview Answer

GitHub Secrets are used for sensitive values like tokens, credentials, and passwords. GitHub Variables are used for non-sensitive configuration like region, environment name, or application name.

In production, I would avoid storing secrets in source code. I would use repository secrets for repo-specific automation, organization secrets for shared values, and environment secrets for deployment credentials.

For production deployments, I would combine environment secrets with environment approval gates so credentials are only available after approval.