# Kubescape NSA Framework Scan Comparison

## Objective

This report compares Kubescape scan results before and after remediating Kubernetes manifest security issues.

Kubescape was used through a Dockerized CLI image instead of installing the tool directly in WSL.

---

## Tool Execution Method

Kubescape was executed using a custom local Docker CLI image:

```text
local/kubescape-cli:latest
```

This keeps the WSL environment clean and makes the lab more repeatable.

---

## Files Compared

| File | Purpose |
|---|---|
| `manifests/vulnerable-deployment.yaml` | Intentionally weak Kubernetes Deployment |
| `fixed-manifests/fixed-deployment.yaml` | Remediated Deployment |
| `fixed-manifests/network-policy.yaml` | NetworkPolicy for ingress and egress control |
| `fixed-manifests/pod-disruption-budget.yaml` | PodDisruptionBudget for availability |

---

## Framework Used

```text
NSA
```

Kubescape scanned the manifests against NSA-style Kubernetes security controls.

---

## Before Fix Result

The vulnerable manifest produced:

```text
Framework scanned: NSA
Controls: 20
Passed: 12
Failed: 8
Compliance score: 60.00%
```

Failed controls included:

```text
Ensure CPU limits are set
Ensure memory limits are set
Non-root containers
Allow privilege escalation
Ingress and Egress blocked
Automatic mapping of service account
Linux hardening
Immutable container filesystem
```

Severity summary:

```text
Critical: 0
High: 2
Medium: 5
Low: 1
```

---

## After Fix Result

The remediated manifest set produced:

```text
Framework scanned: NSA
Controls: 20
Passed: 20
Failed: 0
Compliance score: 100.00%
```

Severity summary:

```text
Critical: 0
High: 0
Medium: 0
Low: 0
```

---

## Remediations Applied

| Issue | Fix |
|---|---|
| CPU limits missing | Added CPU requests and limits |
| Memory limits missing | Added memory requests and limits |
| Container may run as root | Added non-root user and group |
| Privilege escalation allowed | Set `allowPrivilegeEscalation: false` |
| Missing ingress/egress control | Added NetworkPolicy |
| Service account token auto-mounted | Set `automountServiceAccountToken: false` |
| Linux hardening missing | Added security context and dropped capabilities |
| Writable root filesystem | Set `readOnlyRootFilesystem: true` |
| Missing namespace | Added `secure-workloads` namespace |
| Availability protection missing | Added PodDisruptionBudget |
| Scheduling availability missing | Added pod anti-affinity |

---

## Dockerized CLI Lesson

The official Kubescape image pulled from Quay started as a service-style image using:

```text
Entrypoint: ksserver
```

It did not behave like a simple CLI image.

To keep the workflow clean, a custom Dockerfile was created to build a local Kubescape CLI image.

Benefits:

```text
No direct Kubescape installation in WSL
Repeatable tool execution
Easy cleanup
Portable lab workflow
Closer to CI/CD execution style
```

---

## Important Warnings Observed

Kubescape printed warnings such as:

```text
repository host 'github-lingarajayli' not supported
git not found in PATH
PodDisruptionBudget expected v1beta1, actual v1
```

These warnings did not block the scan.

The final after-fix result still passed:

```text
Passed: 20
Failed: 0
Compliance score: 100.00%
```

---

## Key Learning

Kubescape checks Kubernetes manifests against security frameworks.

Unlike kube-score, which focuses heavily on production-readiness, Kubescape provides framework-based security posture checks.

Unlike Trivy config, which focuses on misconfiguration detection, Kubescape provides compliance-style control results.

---

## Tool Comparison

| Tool | Main Focus |
|---|---|
| kube-score | Kubernetes production-readiness |
| Trivy config | Kubernetes misconfiguration scanning |
| Kubescape | Kubernetes security posture and framework controls |

Together, these tools provide better Kubernetes security coverage.

---

## Production Best Practices Demonstrated

```text
Run containers as non-root
Disable privilege escalation
Drop unnecessary Linux capabilities
Use read-only root filesystem
Set CPU and memory requests
Set CPU and memory limits
Disable service account token auto-mount when not needed
Use NetworkPolicy
Use PodDisruptionBudget
Use namespaces instead of default namespace
Scan manifests before deployment
```

---

## Interview Explanation

Kubescape is a Kubernetes security posture scanning tool.

It can scan Kubernetes manifests or live clusters against frameworks such as NSA-style Kubernetes hardening controls.

In this lab, I used Kubescape through a Dockerized CLI instead of installing it directly in WSL.

I scanned an intentionally weak Kubernetes Deployment and Kubescape reported 8 failed controls with a 60% compliance score.

Then I remediated the manifest by adding resource limits, non-root execution, privilege escalation prevention, NetworkPolicy, service account token auto-mount disablement, Linux hardening, read-only root filesystem, PodDisruptionBudget, and namespace isolation.

After remediation, Kubescape reported 20 passed controls, 0 failed controls, and 100% compliance score.

This demonstrates how Kubescape can be used in a DevSecOps workflow to validate Kubernetes security posture before deployment.

---

## Lab Status

```text
Tool: Kubescape
Execution method: Dockerized CLI
Framework: NSA
Before-fix result: 12 passed, 8 failed, 60%
After-fix result: 20 passed, 0 failed, 100%
Status: Completed
```