# Kubescape Kubernetes Security Posture Lab

![Kubescape](https://img.shields.io/badge/Kubescape-Kubernetes%20Security-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Security%20Posture-326CE5?logo=kubernetes&logoColor=white)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Compliance%20Checks-red)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to use Kubescape to scan Kubernetes manifests against security framework controls.

The goal is to validate Kubernetes security posture before deployment.

Kubescape was executed using a Dockerized CLI image instead of installing the tool directly in WSL.

---

## What is Kubescape?

Kubescape is a Kubernetes security posture scanning tool.

It can scan:

```text
Kubernetes manifests
Helm charts
Live Kubernetes clusters
Security framework controls
Compliance-style checks
```

In this lab, Kubescape was used to scan local Kubernetes YAML manifests.

---

## Why This Matters

A Kubernetes manifest can be valid and deploy successfully, but still fail important security controls.

Common issues include:

```text
Containers running as root
Privilege escalation enabled
Missing CPU and memory limits
Writable root filesystem
Service account token auto-mounted unnecessarily
Missing NetworkPolicy
Missing Linux hardening settings
```

Kubescape helps detect these risks before deployment.

---

## Lab Structure

```text
labs/security/kubernetes-scanning/kubescape/
├── README.md
├── docker/
│   └── Dockerfile
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
    ├── kubescape-after-fix.txt
    └── kubescape-before-fix.txt
```

---

## Dockerized Kubescape CLI

The official Kubescape image pulled from Quay started as a service-style image:

```text
Entrypoint: ksserver
```

It was not suitable as a simple CLI container.

So this lab builds a local Kubescape CLI image.

Build:

```bash
docker build -t local/kubescape-cli:latest \
  labs/security/kubernetes-scanning/kubescape/docker
```

Verify:

```bash
docker run --rm local/kubescape-cli:latest version
```

Example version used:

```text
Kubescape v4.0.10
```

---

## Dockerfile

```dockerfile
FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y curl ca-certificates bash && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash

ENTRYPOINT ["kubescape"]
```

---

## Framework Used

This lab scans against the NSA framework:

```text
NSA
```

Run format:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa <manifest-path>
```

---

## Vulnerable Manifest Scan

Run:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa \
  labs/security/kubernetes-scanning/kubescape/manifests/vulnerable-deployment.yaml
```

Save report:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa \
  labs/security/kubernetes-scanning/kubescape/manifests/vulnerable-deployment.yaml \
  > labs/security/kubernetes-scanning/kubescape/reports/kubescape-before-fix.txt
```

---

## Before Fix Result

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

## Fixed Manifest Scan

Run:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa \
  labs/security/kubernetes-scanning/kubescape/fixed-manifests
```

Save report:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa \
  labs/security/kubernetes-scanning/kubescape/fixed-manifests \
  > labs/security/kubernetes-scanning/kubescape/reports/kubescape-after-fix.txt
```

---

## After Fix Result

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

| Issue | Remediation |
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

## Important Warnings Observed

Kubescape printed warnings such as:

```text
repository host 'github-lingarajayli' not supported
git not found in PATH
PodDisruptionBudget expected v1beta1, actual v1
```

These warnings did not block the scan.

The final result still passed:

```text
Passed: 20
Failed: 0
Compliance score: 100.00%
```

---

## Kubescape vs kube-score vs Trivy

| Tool | Main Focus |
|---|---|
| kube-score | Kubernetes production-readiness checks |
| Trivy config | Kubernetes misconfiguration scanning |
| Kubescape | Kubernetes security posture and framework controls |

These tools complement each other.

A strong DevSecOps workflow can use all three before deployment.

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
Use containerized scanner tooling
```

---

## CI/CD Usage

Kubescape can be used in CI/CD to block insecure Kubernetes manifests.

Example policy:

```text
Run Kubescape scan on pull requests
Fail pipeline if important controls fail
Store scan report as artifact
Review failed controls before merge
Scan both manifests and live clusters
```

Example command:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  local/kubescape-cli:latest \
  scan framework nsa \
  labs/security/kubernetes-scanning/kubescape/fixed-manifests
```

---

## Common Mistakes

```text
Thinking valid YAML means secure YAML
Running containers as root by default
Forgetting to disable service account token auto-mount
Not setting resource limits
Not using NetworkPolicy
Ignoring framework-based security posture checks
Installing every tool directly into the workstation
Using service-style container images as if they were CLI images
```

---

## Interview Explanation

Kubescape is a Kubernetes security posture scanning tool.

It can scan Kubernetes manifests or live clusters against framework-based controls such as NSA-style Kubernetes hardening checks.

In this lab, I avoided installing Kubescape directly in WSL. Instead, I built a Dockerized Kubescape CLI image and used it to scan Kubernetes manifests.

The vulnerable manifest failed 8 controls and had a 60% compliance score.

I remediated the manifest by adding CPU and memory limits, non-root execution, privilege escalation prevention, NetworkPolicy, service account token auto-mount disablement, Linux hardening, read-only root filesystem, PodDisruptionBudget, and namespace isolation.

After remediation, Kubescape reported 20 passed controls, 0 failed controls, and a 100% compliance score.

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