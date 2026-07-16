# Trivy Kubernetes Manifest Scan Comparison

## Objective

This report compares Trivy Kubernetes manifest scanning results before and after remediation.

Trivy was used to scan Kubernetes YAML files for misconfigurations.

---

## Files Compared

| File | Purpose |
|---|---|
| `manifests/vulnerable-deployment.yaml` | Intentionally weak Kubernetes Deployment |
| `fixed-manifests/fixed-deployment.yaml` | Remediated Deployment |
| `fixed-manifests/network-policy.yaml` | NetworkPolicy for traffic control |
| `fixed-manifests/pod-disruption-budget.yaml` | PodDisruptionBudget for availability |

---

## Before Fix Result

The vulnerable Deployment produced:

```text
Total misconfigurations: 19
HIGH: 3
MEDIUM: 5
LOW: 11
CRITICAL: 0
```

Main issues included:

```text
allowPrivilegeEscalation not disabled
Linux capabilities not dropped
CPU limits missing
runAsNonRoot not enabled
nginx:latest image tag used
readOnlyRootFilesystem not enabled
securityContext missing
Workload running in default namespace
```

---

## After Fix Result

The fixed manifest set produced:

```text
fixed-deployment.yaml: 0 misconfigurations
network-policy.yaml: 0 misconfigurations
pod-disruption-budget.yaml: 0 misconfigurations
```

---

## Remediations Applied

| Issue | Fix |
|---|---|
| `nginx:latest` image used | Replaced with pinned image tag |
| Missing namespace | Added `secure-workloads` namespace |
| Missing CPU/memory limits | Added resource requests and limits |
| Missing ephemeral storage controls | Added ephemeral storage request and limit |
| Container may run as root | Added non-root user and group |
| Privilege escalation allowed | Set `allowPrivilegeEscalation: false` |
| Default Linux capabilities available | Dropped all capabilities |
| Root filesystem writable | Enabled `readOnlyRootFilesystem: true` |
| Missing pod security context | Added pod-level `securityContext` |
| Missing NetworkPolicy | Added NetworkPolicy |
| Missing disruption protection | Added PodDisruptionBudget |
| Missing availability scheduling rule | Added pod anti-affinity |

---

## Key Difference: Trivy vs kube-score

| Tool | Focus |
|---|---|
| kube-score | Kubernetes production-readiness best practices |
| Trivy config | Kubernetes misconfiguration and security scanning |

Both tools are useful.

kube-score is good for production-readiness checks.

Trivy is good for security-focused misconfiguration scanning and can also scan images, filesystems, repositories, IaC, and Kubernetes manifests.

---

## Important Learning

A Kubernetes manifest can be valid YAML and still be insecure.

Trivy helps detect security misconfigurations before deployment.

This supports a shift-left DevSecOps workflow because problems are found during development or CI/CD instead of after workloads are running in production.

---

## Production Best Practices Demonstrated

```text
Avoid latest image tags
Use namespaces instead of default namespace
Set resource requests and limits
Run containers as non-root
Disable privilege escalation
Use read-only root filesystem where possible
Drop unnecessary Linux capabilities
Use NetworkPolicy
Use PodDisruptionBudget
Scan manifests before deployment
```

---

## Interview Explanation

Trivy is commonly known for container image scanning, but it can also scan Kubernetes manifests and IaC files for misconfigurations.

In this lab, I used `trivy config` to scan an intentionally weak Kubernetes Deployment.

The first scan found 19 misconfigurations, including missing resource limits, missing security context, use of `nginx:latest`, privilege escalation risk, and writable root filesystem.

I then created a fixed manifest set with a pinned image tag, namespace, resource requests and limits, non-root execution, dropped Linux capabilities, read-only root filesystem, NetworkPolicy, and PodDisruptionBudget.

After remediation, Trivy reported 0 misconfigurations for all fixed manifests.

This demonstrates how Trivy can be used as part of a DevSecOps pipeline to detect Kubernetes security misconfigurations before deployment.

---

## Lab Status

```text
Tool: Trivy
Command: trivy config
Category: Kubernetes manifest misconfiguration scanning
Before-fix result: 19 misconfigurations
After-fix result: 0 misconfigurations
Status: Completed
```