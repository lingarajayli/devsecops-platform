# Trivy Kubernetes Manifest Scanning Lab

![Trivy](https://img.shields.io/badge/Trivy-Kubernetes%20Config%20Scanning-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Manifest%20Security-326CE5?logo=kubernetes&logoColor=white)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Shift%20Left-red)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to use Trivy to scan Kubernetes YAML manifests for security misconfigurations.

The goal is to understand that Trivy is not only used for Docker image scanning. It can also scan Kubernetes manifests, IaC files, repositories, and filesystems.

---

## What is Trivy Config Scanning?

`trivy config` scans configuration files for misconfigurations.

It can scan:

```text
Kubernetes YAML
Terraform
Helm charts
Dockerfiles
CloudFormation
Ansible
Azure ARM templates
```

In this lab, Trivy is used to scan Kubernetes manifests.

---

## Why This Matters

A Kubernetes manifest can be syntactically correct and still be insecure.

For example, a Deployment may run successfully but still have problems such as:

```text
Container running as root
Privilege escalation allowed
Writable root filesystem
Missing resource limits
Missing securityContext
Using latest image tag
Running workloads in default namespace
Missing NetworkPolicy
```

Trivy helps catch these issues before deployment.

---

## Lab Structure

```text
labs/security/kubernetes-scanning/trivy-k8s/
├── README.md
├── fixed-manifests/
│   ├── fixed-deployment.yaml
│   ├── network-policy.yaml
│   └── pod-disruption-budget.yaml
├── manifests/
│   ├── fixed-deployment.yaml
│   ├── network-policy.yaml
│   ├── pod-disruption-budget.yaml
│   └── vulnerable-deployment.yaml
└── reports/
    ├── comparison-summary.md
    ├── trivy-k8s-after-fix.txt
    └── trivy-k8s-before-fix.txt
```

---

## Files

| File | Purpose |
|---|---|
| `manifests/vulnerable-deployment.yaml` | Intentionally weak Kubernetes Deployment |
| `fixed-manifests/fixed-deployment.yaml` | Remediated Deployment used for after-fix scan |
| `fixed-manifests/network-policy.yaml` | NetworkPolicy for the remediated workload |
| `fixed-manifests/pod-disruption-budget.yaml` | PodDisruptionBudget for availability |
| `reports/trivy-k8s-before-fix.txt` | Trivy scan output before remediation |
| `reports/trivy-k8s-after-fix.txt` | Trivy scan output after remediation |
| `reports/comparison-summary.md` | Human-readable before/after summary |

---

## Tool Version

```bash
trivy --version
```

Example version used:

```text
Trivy 0.72.0
```

---

## Vulnerable Manifest Scan

Run:

```bash
trivy config labs/security/kubernetes-scanning/trivy-k8s/manifests/vulnerable-deployment.yaml
```

Save report:

```bash
trivy config labs/security/kubernetes-scanning/trivy-k8s/manifests/vulnerable-deployment.yaml \
  > labs/security/kubernetes-scanning/trivy-k8s/reports/trivy-k8s-before-fix.txt
```

---

## Before Fix Result

The vulnerable manifest produced:

```text
Total misconfigurations: 19
HIGH: 3
MEDIUM: 5
LOW: 11
CRITICAL: 0
```

Main findings included:

```text
Privilege escalation not disabled
Linux capabilities not dropped
CPU limits missing
runAsNonRoot not enabled
nginx:latest image tag used
readOnlyRootFilesystem not enabled
securityContext missing
Workload running in default namespace
```

---

## Important Trivy Command Lesson

`trivy config` accepts one target at a time:

```text
trivy config DIR_OR_FILE
```

This works:

```bash
trivy config labs/security/kubernetes-scanning/trivy-k8s/fixed-manifests
```

This does not work:

```bash
trivy config file1.yaml file2.yaml file3.yaml
```

If multiple fixed YAML files must be scanned together, place them inside one directory and scan the directory.

---

## Fixed Manifest Scan

Run:

```bash
trivy config labs/security/kubernetes-scanning/trivy-k8s/fixed-manifests
```

Save report:

```bash
trivy config labs/security/kubernetes-scanning/trivy-k8s/fixed-manifests \
  > labs/security/kubernetes-scanning/trivy-k8s/reports/trivy-k8s-after-fix.txt
```

---

## After Fix Result

The remediated manifests produced:

```text
fixed-deployment.yaml: 0 misconfigurations
network-policy.yaml: 0 misconfigurations
pod-disruption-budget.yaml: 0 misconfigurations
```

---

## Remediations Applied

| Issue | Remediation |
|---|---|
| `nginx:latest` image used | Replaced with pinned image tag |
| Workload in default namespace | Added `secure-workloads` namespace |
| Missing CPU and memory controls | Added resource requests and limits |
| Missing ephemeral storage controls | Added ephemeral storage request and limit |
| Container may run as root | Added non-root user and group |
| Privilege escalation allowed | Set `allowPrivilegeEscalation: false` |
| Linux capabilities available | Dropped all capabilities |
| Writable root filesystem | Set `readOnlyRootFilesystem: true` |
| Missing pod security context | Added pod-level `securityContext` |
| Missing NetworkPolicy | Added NetworkPolicy |
| Missing disruption protection | Added PodDisruptionBudget |
| Missing availability rule | Added pod anti-affinity |

---

## Trivy vs kube-score

| Tool | Primary Use |
|---|---|
| kube-score | Kubernetes production-readiness best practices |
| Trivy config | Security-focused misconfiguration scanning |
| Trivy image | Container image vulnerability scanning |

Both tools are useful together.

kube-score helps improve production readiness.

Trivy helps detect Kubernetes security misconfigurations.

---

## Production Best Practices Demonstrated

```text
Avoid latest image tags
Use namespaces instead of default namespace
Set CPU and memory requests
Set CPU and memory limits
Set ephemeral storage requests and limits
Run containers as non-root
Disable privilege escalation
Use read-only root filesystem where possible
Drop unnecessary Linux capabilities
Use NetworkPolicy
Use PodDisruptionBudget
Scan manifests before deployment
```

---

## CI/CD Usage

In production, Trivy config scanning can be added to CI/CD pipelines.

Example policy:

```text
Run Trivy config scan on every pull request
Fail pipeline on HIGH or CRITICAL misconfigurations
Store scan reports as pipeline artifacts
Review misconfiguration findings before merge
Block unsafe Kubernetes manifests from deployment
```

Example command for gating:

```bash
trivy config \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  labs/security/kubernetes-scanning/trivy-k8s/fixed-manifests
```

---

## Common Mistakes

```text
Thinking Trivy only scans Docker images
Trying to pass multiple file paths to trivy config
Scanning only after deployment instead of before deployment
Ignoring LOW/MEDIUM findings completely
Using latest image tags
Running workloads in the default namespace
Not setting securityContext
Not setting resource limits
```

---

## Interview Explanation

Trivy is commonly used for container image vulnerability scanning, but it also supports Kubernetes manifest and IaC misconfiguration scanning using `trivy config`.

In this lab, I scanned an intentionally weak Kubernetes Deployment manifest. Trivy detected 19 misconfigurations, including missing security context, privilege escalation risk, missing resource limits, use of `nginx:latest`, writable root filesystem, and workload running in the default namespace.

I then remediated the manifest by adding a namespace, pinned image tag, resource requests and limits, non-root security context, dropped capabilities, read-only root filesystem, NetworkPolicy, PodDisruptionBudget, and pod anti-affinity.

After remediation, Trivy reported 0 misconfigurations for the fixed manifest set.

This demonstrates how Trivy can be used in a DevSecOps workflow to shift Kubernetes security checks left into development and CI/CD.

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