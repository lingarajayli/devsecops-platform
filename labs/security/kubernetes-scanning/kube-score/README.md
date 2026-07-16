# kube-score Kubernetes Manifest Scanning Lab

![Kubernetes](https://img.shields.io/badge/Kubernetes-Manifest%20Scanning-326CE5?logo=kubernetes&logoColor=white)
![kube-score](https://img.shields.io/badge/kube--score-Production%20Readiness-blue)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Shift%20Left-red)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to use `kube-score` to scan Kubernetes YAML manifests before deployment.

The goal is to detect production-readiness issues early, before weak manifests reach a Kubernetes cluster.

---

## What is kube-score?

`kube-score` is a static analysis tool for Kubernetes manifests.

It checks YAML files for common production problems such as:

```text
Missing CPU requests
Missing CPU limits
Missing memory requests
Missing memory limits
Missing ephemeral storage limits
Missing securityContext
Containers running as root
Missing NetworkPolicy
Missing PodDisruptionBudget
Missing pod anti-affinity
Unsafe image configuration
```

---

## Why This Matters

Kubernetes YAML can look correct but still be unsafe or unreliable for production.

For example, a Deployment may run successfully but still have serious issues:

```text
No resource limits can cause noisy-neighbor problems
No requests can cause poor scheduling decisions
No securityContext can allow risky container behavior
No NetworkPolicy can allow unrestricted Pod communication
No PodDisruptionBudget can cause downtime during node maintenance
```

kube-score helps catch these problems during code review or CI/CD.

---

## Lab Structure

```text
labs/security/kubernetes-scanning/kube-score/
├── README.md
├── manifests/
│   ├── fixed-deployment.yaml
│   ├── network-policy.yaml
│   ├── pod-disruption-budget.yaml
│   └── vulnerable-deployment.yaml
└── reports/
    ├── comparison-summary.md
    ├── kube-score-after-fix.txt
    └── kube-score-before-fix.txt
```

---

## Files

| File | Purpose |
|---|---|
| `manifests/vulnerable-deployment.yaml` | Intentionally weak Deployment |
| `manifests/fixed-deployment.yaml` | Improved production-style Deployment |
| `manifests/network-policy.yaml` | NetworkPolicy for the fixed Deployment |
| `manifests/pod-disruption-budget.yaml` | PodDisruptionBudget for safe maintenance |
| `reports/kube-score-before-fix.txt` | kube-score output before remediation |
| `reports/kube-score-after-fix.txt` | kube-score output after remediation |
| `reports/comparison-summary.md` | Human-readable before/after explanation |

---

## Install kube-score

```bash
cd /tmp

KUBE_SCORE_URL=$(curl -s https://api.github.com/repos/zegl/kube-score/releases/latest \
  | jq -r '.assets[].browser_download_url' \
  | grep 'linux_amd64.*tar.gz$' \
  | head -n 1)

wget -O kube-score.tar.gz "$KUBE_SCORE_URL"

tar -xzf kube-score.tar.gz

sudo install -m 0755 kube-score /usr/local/bin/kube-score

kube-score version
```

Example version used:

```text
kube-score version: 1.20.0
```

---

## Vulnerable Manifest

The vulnerable manifest uses a very basic Nginx Deployment.

It intentionally has multiple problems:

```text
Uses nginx:latest
No CPU request
No CPU limit
No memory request
No memory limit
No ephemeral storage request
No ephemeral storage limit
No container securityContext
No pod securityContext
No NetworkPolicy
No PodDisruptionBudget
```

Run scan:

```bash
kube-score score labs/security/kubernetes-scanning/kube-score/manifests/vulnerable-deployment.yaml
```

Save report:

```bash
kube-score score labs/security/kubernetes-scanning/kube-score/manifests/vulnerable-deployment.yaml \
  > labs/security/kubernetes-scanning/kube-score/reports/kube-score-before-fix.txt
```

---

## Fixed Manifest

The improved manifest includes production-style improvements:

```text
Pinned image tag
CPU request
CPU limit
Memory request
Memory limit
Ephemeral storage request
Ephemeral storage limit
Pod securityContext
Container securityContext
Non-root container user
Privilege escalation disabled
Read-only root filesystem
Linux capabilities dropped
Pod anti-affinity
NetworkPolicy
PodDisruptionBudget
```

Run scan:

```bash
kube-score score labs/security/kubernetes-scanning/kube-score/manifests/fixed-deployment.yaml \
  labs/security/kubernetes-scanning/kube-score/manifests/network-policy.yaml \
  labs/security/kubernetes-scanning/kube-score/manifests/pod-disruption-budget.yaml
```

Save report:

```bash
kube-score score labs/security/kubernetes-scanning/kube-score/manifests/fixed-deployment.yaml \
  labs/security/kubernetes-scanning/kube-score/manifests/network-policy.yaml \
  labs/security/kubernetes-scanning/kube-score/manifests/pod-disruption-budget.yaml \
  > labs/security/kubernetes-scanning/kube-score/reports/kube-score-after-fix.txt
```

---

## Intentional Remaining Finding

The fixed manifest intentionally uses:

```yaml
imagePullPolicy: IfNotPresent
```

kube-score recommends:

```yaml
imagePullPolicy: Always
```

For this local Kind lab, `IfNotPresent` is accepted because:

```text
It avoids repeated image pulls
It saves bandwidth
It makes local testing faster
It works well for local learning environments
```

Production note:

```text
In production, image pull policy should follow the organization’s deployment policy.
A strong approach is to use immutable image tags or image digests.
Never rely on latest tags in production.
```

---

## NetworkPolicy and CNI Note

This lab includes a NetworkPolicy.

However, NetworkPolicy enforcement depends on the CNI plugin.

The local Kind cluster uses:

```text
CNI: kindnet
```

kindnet provides basic Pod networking, but real NetworkPolicy enforcement normally requires a CNI such as:

```text
Calico
Cilium
Antrea
```

So in this lab:

```text
NetworkPolicy YAML exists
kube-score check passes
Actual runtime enforcement depends on the cluster CNI
```

---

## Before vs After

| Check | Vulnerable Manifest | Fixed Manifest |
|---|---|---|
| Fixed image tag | Failed | Passed |
| CPU request | Failed | Passed |
| CPU limit | Failed | Passed |
| Memory request | Failed | Passed |
| Memory limit | Failed | Passed |
| Ephemeral storage request | Failed | Passed |
| Ephemeral storage limit | Failed | Passed |
| Pod securityContext | Failed | Passed |
| Container securityContext | Failed | Passed |
| Non-root execution | Failed | Passed |
| Privilege escalation disabled | Failed | Passed |
| Read-only root filesystem | Failed | Passed |
| Linux capabilities dropped | Failed | Passed |
| NetworkPolicy | Failed | Passed |
| PodDisruptionBudget | Failed | Passed |
| Pod anti-affinity | Failed | Passed |
| Avoid latest image tag | Failed | Passed |

---

## Production Best Practices Demonstrated

```text
Set CPU and memory requests
Set CPU and memory limits
Set ephemeral storage requests and limits
Avoid latest image tags
Use non-root containers
Disable privilege escalation
Use read-only root filesystem where possible
Drop unnecessary Linux capabilities
Use PodDisruptionBudget for availability
Use NetworkPolicy for traffic control
Use pod anti-affinity for better availability
Scan manifests before deployment
```

---

## Common Mistakes

```text
Thinking a running Pod means production-ready
Forgetting resource requests and limits
Using latest image tags
Ignoring securityContext
Creating NetworkPolicy without checking CNI support
Not defining PodDisruptionBudget for replicated apps
Committing YAML without static checks
```

---

## Interview Explanation

kube-score is a Kubernetes manifest static analysis tool.

It checks YAML files before deployment and identifies production-readiness problems such as missing resource requests and limits, missing security contexts, missing NetworkPolicies, missing PodDisruptionBudgets, and unsafe image configuration.

In this lab, I created an intentionally weak Nginx Deployment and scanned it with kube-score. The scan reported multiple critical issues.

Then I created an improved manifest with resource requests and limits, non-root execution, dropped capabilities, read-only root filesystem, NetworkPolicy, PodDisruptionBudget, and pod anti-affinity.

The only intentionally accepted finding is `imagePullPolicy: IfNotPresent`, because this is a local Kind learning environment. In production, I would follow the organization’s image deployment policy and prefer immutable tags or image digests.

This shows how Kubernetes manifest scanning can be shifted left into CI/CD before workloads are deployed.

---

## Lab Status

```text
Tool: kube-score
Category: Kubernetes manifest scanning
Cluster required: No
Before-fix scan: Completed
After-fix scan: Completed
NetworkPolicy added: Yes
PodDisruptionBudget added: Yes
Status: Completed
```