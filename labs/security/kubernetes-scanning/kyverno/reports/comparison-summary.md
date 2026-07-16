# Kyverno Policy Enforcement Comparison

## Objective

This report documents how Kyverno was used to enforce Kubernetes admission policies inside a local Kind cluster.

The goal was to move from security scanning to security enforcement.

---

## Why Kyverno?

Previous tools in this lab series were used to detect issues:

| Tool | Purpose |
|---|---|
| kube-score | Production-readiness checks |
| Trivy config | Kubernetes misconfiguration scanning |
| Kubescape | Kubernetes security posture scanning |

Kyverno is different because it can block unsafe Kubernetes resources before they are admitted into the cluster.

---

## Policy Tested

Policy name:

```text
disallow-latest-tag
```

Policy type:

```text
ClusterPolicy
```

Validation mode:

```text
Enforce
```

Purpose:

```text
Block container images that use the latest tag.
```

---

## Why Blocking `latest` Matters

Using the `latest` tag is risky because:

```text
It is mutable
It is not repeatable
It can change without a Git commit
It makes rollback difficult
It makes incident investigation harder
It breaks supply-chain traceability
```

In production, fixed image tags or immutable digests are preferred.

---

## Installation Method

Kyverno was installed into a local Kind cluster using a Helm-rendered manifest.

The manifest was generated with:

```bash
helm template kyverno kyverno/kyverno \
  --namespace kyverno \
  --no-hooks \
  > labs/security/kubernetes-scanning/kyverno/install/kyverno-generated.yaml
```

It was applied using server-side apply:

```bash
kubectl apply --server-side \
  -f labs/security/kubernetes-scanning/kyverno/install/kyverno-generated.yaml
```

---

## Important Installation Lessons

### 1. Large CRDs Need Server-Side Apply

Initial client-side apply failed because Kyverno CRDs were too large.

Reason:

```text
kubectl apply stores last-applied-configuration in annotations.
Large CRDs can exceed Kubernetes annotation size limits.
```

Fix:

```bash
kubectl apply --server-side -f <manifest>
```

### 2. Helm Hooks Should Not Be Applied Blindly

Initial Helm-rendered manifest included hook resources such as:

```text
kyverno-scale-to-zero
kyverno-rm-webhooks
kyverno-migrate-resources
```

When applied manually, these caused Kyverno controllers to scale to zero.

Fix:

```bash
helm template ... --no-hooks
```

---

## Kyverno Controller Status

After fixing the installation method, all Kyverno controllers were healthy:

```text
kyverno-admission-controller    1/1
kyverno-background-controller   1/1
kyverno-cleanup-controller      1/1
kyverno-reports-controller      1/1
```

---

## Policy Status

The ClusterPolicy became ready:

```text
NAME                  ADMISSION   BACKGROUND   READY   MESSAGE
disallow-latest-tag   true        true         True    Ready
```

This means Kyverno admission enforcement was active.

---

## Bad Deployment Test

The bad Deployment used:

```text
nginx:latest
```

Command:

```bash
kubectl apply -f labs/security/kubernetes-scanning/kyverno/manifests/bad-deployment.yaml
```

Result:

```text
admission webhook "validate.kyverno.svc-fail" denied the request
resource Deployment/default/bad-nginx-latest was blocked
Images must not use the latest tag. Use a fixed version tag.
```

Outcome:

```text
Blocked by Kyverno
```

---

## Good Deployment Test

The good Deployment used:

```text
nginx:1.27-alpine
```

Command:

```bash
kubectl apply -f labs/security/kubernetes-scanning/kyverno/manifests/good-deployment.yaml
```

Result:

```text
deployment.apps/good-nginx-fixed-tag created
```

Deployment status:

```text
good-nginx-fixed-tag   1/1
```

Pod status:

```text
good-nginx-fixed-tag   Running
```

Outcome:

```text
Allowed by Kyverno
```

---

## Before vs After

| Test | Image | Result |
|---|---|---|
| Bad Deployment | `nginx:latest` | Denied |
| Good Deployment | `nginx:1.27-alpine` | Allowed |

---

## Key Learning

Kyverno acts as a Kubernetes admission controller.

It validates resources during creation or update and can block resources that violate policy.

In this lab, Kyverno blocked a Deployment using the unsafe `latest` image tag and allowed a Deployment using a fixed version tag.

This demonstrates real Kubernetes policy enforcement.

---

## DevSecOps Value

Kyverno helps shift security left inside Kubernetes by enforcing rules before workloads run.

Production teams can use Kyverno to enforce:

```text
No latest image tags
Required labels
Required resource limits
Non-root containers
Allowed image registries
Required NetworkPolicies
Restricted hostPath usage
Restricted privileged containers
Required security contexts
```

---

## Interview Explanation

Kyverno is a Kubernetes-native policy engine.

It runs as an admission controller and can validate, mutate, generate, or verify Kubernetes resources.

In this lab, I installed Kyverno in a local Kind cluster using Helm-rendered manifests. I learned that large Kyverno CRDs require server-side apply, and Helm hook resources should be excluded when applying rendered manifests manually.

Then I created a ClusterPolicy to block container images using the `latest` tag.

When I applied a Deployment using `nginx:latest`, Kyverno denied it through the admission webhook.

When I applied a Deployment using `nginx:1.27-alpine`, Kyverno allowed it and the Pod ran successfully.

This shows how Kyverno can enforce DevSecOps guardrails directly inside Kubernetes.

---

## Lab Status

```text
Tool: Kyverno
Cluster: Kind
Policy type: ClusterPolicy
Mode: Enforce
Bad deployment: Denied
Good deployment: Allowed
Status: Completed
```