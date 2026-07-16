# kube-score Scan Comparison

## Objective

This report compares a weak Kubernetes Deployment manifest with an improved production-style manifest using kube-score.

kube-score checks Kubernetes YAML files for production-readiness issues before deployment.

---

## Files Compared

| File | Purpose |
|---|---|
| `manifests/vulnerable-deployment.yaml` | Intentionally weak Kubernetes Deployment |
| `manifests/fixed-deployment.yaml` | Improved Deployment manifest |
| `manifests/network-policy.yaml` | NetworkPolicy for the fixed Deployment |
| `manifests/pod-disruption-budget.yaml` | PodDisruptionBudget for the fixed Deployment |

---

## Before Fix Result

The vulnerable Deployment had multiple critical findings.

Main issues detected:

```text
No container securityContext
No CPU request
No CPU limit
No memory request
No memory limit
No ephemeral storage request
No ephemeral storage limit
Uses nginx:latest
No NetworkPolicy
```

---

## After Fix Result

The improved manifest fixed most production-readiness problems.

Fixed improvements:

```text
Pinned image tag
CPU request added
CPU limit added
Memory request added
Memory limit added
Ephemeral storage request added
Ephemeral storage limit added
Pod securityContext added
Container securityContext added
Container runs as non-root user
Privilege escalation disabled
Read-only root filesystem enabled
Linux capabilities dropped
NetworkPolicy added
PodDisruptionBudget added
Pod anti-affinity added
```

---

## Intentional Remaining Finding

kube-score still reports:

```text
Container Image Pull Policy is not set to Always
```

This lab intentionally uses:

```yaml
imagePullPolicy: IfNotPresent
```

Reason:

```text
For local Kind learning, IfNotPresent avoids repeated image pulls, saves bandwidth, and makes labs faster.
```

Production note:

```text
In production, image pull policy depends on the deployment strategy.

A common secure approach is to use immutable image tags or image digests.
Some teams use imagePullPolicy: Always.
Some teams use IfNotPresent with immutable tags or digests.
The important rule is: never rely on latest tags in production.
```

---

## NetworkPolicy Note

This Kind cluster uses `kindnet` as the default CNI.

kindnet provides basic Pod networking, but real NetworkPolicy enforcement requires a CNI that supports NetworkPolicy enforcement, such as:

```text
Calico
Cilium
Antrea
```

In this lab, NetworkPolicy is included to satisfy production manifest best practices and kube-score checks.

---

## Before vs After Summary

| Check | Vulnerable Manifest | Fixed Manifest |
|---|---|---|
| Fixed image tag | Failed | Passed |
| CPU request | Failed | Passed |
| CPU limit | Failed | Passed |
| Memory request | Failed | Passed |
| Memory limit | Failed | Passed |
| Ephemeral storage request | Failed | Passed |
| Ephemeral storage limit | Failed | Passed |
| Container securityContext | Failed | Passed |
| Runs as non-root | Failed | Passed |
| Read-only root filesystem | Failed | Passed |
| Linux capabilities dropped | Failed | Passed |
| NetworkPolicy | Failed | Passed |
| PodDisruptionBudget | Failed | Passed |
| Pod anti-affinity | Failed | Passed |
| imagePullPolicy Always | Failed | Intentionally accepted for local Kind |

---

## Key Learning

kube-score helps detect Kubernetes manifest issues before they reach a cluster.

This is useful in DevSecOps because many Kubernetes security and reliability problems can be caught during code review or CI/CD before deployment.

---

## Interview Explanation

kube-score is a static analysis tool for Kubernetes manifests.

It checks whether YAML files follow production-readiness best practices such as setting resource requests and limits, avoiding latest image tags, adding security contexts, using NetworkPolicies, and defining PodDisruptionBudgets.

In this lab, I scanned an intentionally weak Nginx Deployment. kube-score reported missing resources, missing security context, latest image tag usage, missing NetworkPolicy, and missing PodDisruptionBudget.

I then created a fixed manifest with resource requests and limits, non-root execution, dropped capabilities, read-only root filesystem, NetworkPolicy, PodDisruptionBudget, and pod anti-affinity.

One finding remains intentionally because I used `imagePullPolicy: IfNotPresent` for a local Kind lab to avoid repeated image downloads. In production, I would align this with the organization’s image deployment policy and prefer immutable image tags or image digests.

---

## Lab Status

```text
Tool: kube-score
Category: Kubernetes manifest scanning
Before-fix scan: Completed
After-fix scan: Completed
NetworkPolicy: Added
PodDisruptionBudget: Added
Status: Completed
```