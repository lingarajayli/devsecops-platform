# Semgrep SAST Scan Comparison

## Files Compared

| File | Purpose | Findings |
|---|---|---:|
| `vulnerable-app/app.py` | Vulnerable example | 7 |
| `vulnerable-app/app-fixed.py` | Fixed example | 0 |

---

## Vulnerabilities Detected

| Vulnerability Type | Vulnerable Pattern | Fixed Pattern |
|---|---|---|
| Command injection | User input passed into `os.system()` | `subprocess.run()` with argument list and `shell=False` |
| SQL injection | User input concatenated into SQL query | Parameterized SQL query using `?` placeholder |
| Missing input validation | Raw request parameters used directly | IP address and numeric user ID validation |

---

## Key Finding

Semgrep detected insecure source-code patterns before runtime.

The vulnerable file had 7 blocking findings. After fixing command execution, SQL query handling, and input validation, the fixed file had 0 findings.

---

## Lesson Learned

SAST tools help detect insecure coding patterns early in the development lifecycle.

Common issues found by SAST include:

```text
Command injection
SQL injection
Hardcoded secrets
Unsafe deserialization
Path traversal
Insecure cryptography
Misconfigured framework usage
```

---

## Remediation Strategy

```text
1. Identify insecure source-code pattern
2. Understand whether user input reaches dangerous functions
3. Replace unsafe functions with safer alternatives
4. Add input validation
5. Use parameterized queries
6. Re-scan after fixing
7. Add CI/CD gate to prevent insecure code from merging
```

---

## Why This Fix Works

### Command Injection Fix

The vulnerable code used:

```python
os.system("ping -c 1 " + host)
```

This is dangerous because user input becomes part of a shell command.

The fixed code uses:

```python
subprocess.run(
    ["ping", "-c", "1", host],
    check=False,
    shell=False,
)
```

This is safer because command arguments are passed as a list and shell execution is disabled.

---

### SQL Injection Fix

The vulnerable code used:

```python
query = "SELECT * FROM users WHERE id = " + user_id
cursor.execute(query)
```

This is dangerous because user input becomes part of the SQL query string.

The fixed code uses:

```python
cursor.execute(
    "SELECT * FROM users WHERE id = ?",
    (user_id,),
)
```

This is safer because the database driver treats `user_id` as a parameter, not executable SQL.

---

## Interview Explanation

Semgrep is a SAST tool used to scan source code for insecure patterns.

In this lab, Semgrep detected command injection and SQL injection risks in a Python Flask application.

The vulnerable code used `os.system()` with user input and manually concatenated user input into a SQL query.

I fixed the issues by using `subprocess.run()` with an argument list, disabling shell execution, validating input, and using parameterized SQL queries.

After the fix, Semgrep findings reduced from 7 to 0.

This shows how SAST can help catch security issues before code reaches production.

---

## Lab Status

```text
Tool: Semgrep
Scan type: SAST
Before-fix findings: 7
After-fix findings: 0
Vulnerabilities tested: Command injection, SQL injection
Status: Completed
```