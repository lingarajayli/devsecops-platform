# Semgrep SAST Lab

![Semgrep](https://img.shields.io/badge/Semgrep-SAST-blue)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Code%20Security-red)
![Python](https://img.shields.io/badge/Python-Flask-3776AB?logo=python&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to use Semgrep for Static Application Security Testing.

The goal is to understand:

```text
How SAST tools scan source code
How insecure coding patterns are detected
How command injection is identified
How SQL injection is identified
How to fix insecure code
How to prove the fix with an after-fix scan
```

---

## What is Semgrep?

Semgrep is a SAST tool used to scan source code for insecure patterns, bugs, and policy violations.

It can detect issues such as:

```text
Command injection
SQL injection
Hardcoded secrets
Path traversal
Unsafe deserialization
Insecure framework usage
Dangerous function calls
```

---

## SAST vs SCA

| Type | Full Form | What It Scans |
|---|---|---|
| SAST | Static Application Security Testing | Source code patterns |
| SCA | Software Composition Analysis | Third-party dependencies and packages |

Semgrep is mainly used for SAST.

Trivy is commonly used for container image scanning, dependency vulnerability scanning, filesystem scanning, IaC scanning, and Kubernetes scanning.

---

## Lab Structure

```text
labs/security/semgrep/
├── README.md
├── reports/
│   ├── comparison-summary.md
│   ├── semgrep-before-fix.json
│   └── semgrep-after-fix.json
└── vulnerable-app/
    ├── app.py
    └── app-fixed.py
```

---

## Files Used

| File | Purpose |
|---|---|
| `vulnerable-app/app.py` | Vulnerable Python Flask example |
| `vulnerable-app/app-fixed.py` | Fixed Python Flask example |
| `reports/semgrep-before-fix.json` | Semgrep JSON report before fixing |
| `reports/semgrep-after-fix.json` | Semgrep JSON report after fixing |
| `reports/comparison-summary.md` | Before/after explanation |

---

## Vulnerabilities Demonstrated

| Vulnerability | Insecure Pattern | Secure Fix |
|---|---|---|
| Command injection | User input passed into `os.system()` | Use `subprocess.run()` with argument list and `shell=False` |
| SQL injection | User input concatenated into SQL query | Use parameterized SQL queries |
| Missing input validation | Raw request parameters used directly | Validate IP address and numeric user ID |

---

## Run Semgrep Scan

### Scan vulnerable file

```bash
semgrep scan \
  --config auto \
  --json \
  --output labs/security/semgrep/reports/semgrep-before-fix.json \
  --include "labs/security/semgrep/vulnerable-app/app.py" \
  .
```

### Count findings

```bash
jq '.results | length' labs/security/semgrep/reports/semgrep-before-fix.json
```

Expected result:

```text
7
```

---

## Scan Fixed File

```bash
semgrep scan \
  --config auto \
  --json \
  --output labs/security/semgrep/reports/semgrep-after-fix.json \
  --include "labs/security/semgrep/vulnerable-app/app-fixed.py" \
  .
```

### Count findings

```bash
jq '.results | length' labs/security/semgrep/reports/semgrep-after-fix.json
```

Expected result:

```text
0
```

---

## Key Result

```text
Before fix: 7 findings
After fix: 0 findings
```

This proves that insecure code was detected, fixed, and re-scanned successfully.

---

## Production Usage

In real DevSecOps pipelines, Semgrep is commonly used to scan source code during:

```text
Developer local checks
Pull request validation
CI/CD security gates
Pre-merge security checks
Secure coding policy enforcement
```

A common production policy is:

```text
Block critical/high-confidence insecure code patterns
Review medium severity findings
Allow false positives only with documented justification
Keep rule sets versioned and reviewed
```

---

## Interview Explanation

Semgrep is a SAST tool used to scan source code for insecure patterns.

In this lab, I created a vulnerable Python Flask application with command injection and SQL injection risks.

Semgrep detected 7 blocking findings in the vulnerable file.

I fixed the issues by replacing `os.system()` with `subprocess.run()` using an argument list, disabling shell execution, validating user input, and using parameterized SQL queries.

After the fix, Semgrep reported 0 findings.

This demonstrates how SAST helps catch insecure code before it reaches production.

---

## Lab Status

```text
Tool: Semgrep
Version tested: 1.169.0
Scan type: SAST
Before-fix findings: 7
After-fix findings: 0
Status: Completed
```