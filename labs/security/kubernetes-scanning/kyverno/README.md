# Kyverno Kubernetes Policy Enforcement Lab

![Kyverno](https://img.shields.io/badge/Kyverno-Kubernetes%20Policy-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Admission%20Control-326CE5?logo=kubernetes&logoColor=white)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Policy%20Enforcement-red)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## Objective

This lab demonstrates how to use Kyverno to enforce Kubernetes security policies inside a local Kind cluster.

The goal is to move from security scanning to security enforcement.

Previous tools detected problems.

Kyverno blocks unsafe Kubernetes resources before they are admitted into the cluster.

---

## What is Kyverno?

Kyverno is a Kubernetes-native policy engine.

It can:

```text
Validate resources
Mutate resources
Generate resources
Verify images
Enforce admission policies
Create policy reports
```

Kyverno runs inside Kubernetes and works with Kubernetes resources directly.

---

## Why This Matters

A Kubernetes manifest can be valid YAML and still be unsafe.

For example:

```text
image: nginx:latest
```

This is risky because the `latest` tag is mutable.

The same manifest can deploy different image versions at different times.

That causes problems for:

```text
Repeatable deployments
Rollback
Incident investigation
Supply-chain traceability
Production change control
```

Kyverno can block this before the workload runs.

---

## Lab Structure

```text
labs/security/kubernetes-scanning/kyverno/
├── README.md
├── install/
│   ├── kyverno-generated.yaml
│   └── values.yaml
├── manifests/
│   ├── bad-deployment.yaml
│   └── good-deployment.yaml
├── policies/
│   └── disallow-latest-tag.yaml
└── reports/
    ├── bad-deployment-denied.txt
    ├── clusterpolicy-describe.txt
    ├── clusterpolicy-status.txt
    ├── comparison-summary.md
    ├── good-deployment-allowed.txt
    ├── good-deployment-status.txt
    └── good-pod-status.txt
```

---

## Installation Approach

Kyverno was installed using a Helm-rendered manifest.

For platform tools like Kyverno, Helm is better than manually writing all Kubernetes objects because Kyverno includes:

```text
CRDs
RBAC
ServiceAccounts
Deployments
Services
Webhook configuration
Admission controller
Background controller
Cleanup controller
Reports controller
```

For this lab:

```text
Kyverno installation -> Helm-rendered manifest
Kyverno policies     -> Plain YAML
Test workloads       -> Plain YAML
Evidence reports     -> Text and Markdown
```

---

## Generate Kyverno Manifest

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
```

Generate the manifest without Helm hooks:

```bash
helm template kyverno kyverno/kyverno \
  --namespace kyverno \
  --no-hooks \
  > labs/security/kubernetes-scanning/kyverno/install/kyverno-generated.yaml
```

---

## Why `--no-hooks` Was Required

The first generated manifest included Helm hook resources such as:

```text
kyverno-scale-to-zero
kyverno-rm-webhooks
kyverno-migrate-resources
```

When those hook resources were applied manually using `kubectl`, the Kyverno controllers were scaled to zero.

Problem state:

```text
kyverno-admission-controller    0/0
kyverno-background-controller   0/0
kyverno-cleanup-controller      0/0
kyverno-reports-controller      0/0
```

Fix:

```bash
helm template kyverno kyverno/kyverno \
  --namespace kyverno \
  --no-hooks \
  > labs/security/kubernetes-scanning/kyverno/install/kyverno-generated.yaml
```

---

## Apply Kyverno Manifest

Create namespace:

```bash
kubectl create namespace kyverno
```

Apply using server-side apply:

```bash
kubectl apply --server-side \
  -f labs/security/kubernetes-scanning/kyverno/install/kyverno-generated.yaml
```

---

## Why Server-Side Apply Was Required

Client-side apply failed for large Kyverno CRDs.

Error reason:

```text
metadata.annotations: Too long: may not be more than 262144 bytes
```

Why this happens:

```text
kubectl apply stores last-applied-configuration in annotations.
Large CRDs can exceed Kubernetes annotation size limits.
```

Fix:

```bash
kubectl apply --server-side -f <manifest>
```

This avoids storing the full manifest in the client-side last-applied annotation.

---

## Verify Kyverno Installation

```bash
kubectl get pods -n kyverno
kubectl get deployments -n kyverno
```

Expected healthy controllers:

```text
kyverno-admission-controller    1/1
kyverno-background-controller   1/1
kyverno-cleanup-controller      1/1
kyverno-reports-controller      1/1
```

---

## Policy: Disallow Latest Image Tag

Policy file:

```text
policies/disallow-latest-tag.yaml
```

Policy:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-latest-tag
  annotations:
    policies.kyverno.io/title: Disallow Latest Image Tag
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/description: >-
      Using the latest image tag makes deployments non-repeatable and unsafe.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: require-fixed-image-tag
      match:
        any:
          - resources:
              kinds:
                - Pod
      validate:
        message: "Images must not use the latest tag. Use a fixed version tag."
        pattern:
          spec:
            containers:
              - image: "!*:latest"
```

Apply:

```bash
kubectl apply -f labs/security/kubernetes-scanning/kyverno/policies/disallow-latest-tag.yaml
```

Verify:

```bash
kubectl get clusterpolicy
kubectl describe clusterpolicy disallow-latest-tag
```

Expected:

```text
NAME                  ADMISSION   BACKGROUND   READY   MESSAGE
disallow-latest-tag   true        true         True    Ready
```

---

## Important Kyverno Concept: Auto-Generation

The policy was written for Pods.

Kyverno automatically generated equivalent rules for controllers such as:

```text
Deployment
DaemonSet
StatefulSet
Job
CronJob
ReplicaSet
ReplicationController
```

This is why a Pod-level policy can also block a Deployment.

---

## Bad Deployment Test

Bad manifest:

```text
manifests/bad-deployment.yaml
```

It uses:

```text
nginx:latest
```

Run:

```bash
kubectl apply -f labs/security/kubernetes-scanning/kyverno/manifests/bad-deployment.yaml \
  2>&1 | tee labs/security/kubernetes-scanning/kyverno/reports/bad-deployment-denied.txt
```

Result:

```text
admission webhook "validate.kyverno.svc-fail" denied the request
resource Deployment/default/bad-nginx-latest was blocked
Images must not use the latest tag. Use a fixed version tag.
```

Outcome:

```text
Denied by Kyverno
```

---

## Good Deployment Test

Good manifest:

```text
manifests/good-deployment.yaml
```

It uses:

```text
nginx:1.27-alpine
```

Run:

```bash
kubectl apply -f labs/security/kubernetes-scanning/kyverno/manifests/good-deployment.yaml \
  2>&1 | tee labs/security/kubernetes-scanning/kyverno/reports/good-deployment-allowed.txt
```

Result:

```text
deployment.apps/good-nginx-fixed-tag created
```

Verify:

```bash
kubectl get deployment good-nginx-fixed-tag
kubectl get pods -l app.kubernetes.io/instance=good-nginx-fixed-tag
```

Expected:

```text
good-nginx-fixed-tag   1/1
good-nginx-fixed-tag   Running
```

Outcome:

```text
Allowed by Kyverno
```

---

## Evidence Files

```text
reports/bad-deployment-denied.txt
reports/good-deployment-allowed.txt
reports/clusterpolicy-status.txt
reports/clusterpolicy-describe.txt
reports/good-deployment-status.txt
reports/good-pod-status.txt
reports/comparison-summary.md
```

---

## Before vs After

| Test | Image | Result |
|---|---|---|
| Bad Deployment | `nginx:latest` | Denied |
| Good Deployment | `nginx:1.27-alpine` | Allowed |

---

## Production Best Practices Demonstrated

```text
Use admission control for policy enforcement
Block mutable latest image tags
Use fixed image tags or immutable digests
Keep platform installation managed through Helm
Keep custom policies as plain YAML
Store policy evidence in reports
Use server-side apply for large CRDs
Avoid applying Helm hooks blindly with kubectl
Validate both denied and allowed paths
```

---

## Kyverno vs Previous Tools

| Tool | Main Focus |
|---|---|
| kube-score | Production-readiness scanning |
| Trivy config | Kubernetes misconfiguration scanning |
| Kubescape | Kubernetes security posture scanning |
| Kyverno | Kubernetes policy enforcement |

Key difference:

```text
Scanning tools report problems.
Kyverno blocks problems.
```

---

## Real-World Usage

In production, Kyverno can enforce:

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
Image signature verification
```

---

## Common Mistakes

```text
Thinking YAML validation means security validation
Using latest image tags in production
Installing complex platform tools manually
Applying Helm hooks blindly with kubectl
Using client-side apply for large CRDs
Writing policies but leaving them in Audit mode accidentally
Testing only blocked cases and not allowed cases
Forgetting Kyverno can auto-generate controller rules from Pod rules
```

---

## Interview Explanation

Kyverno is a Kubernetes-native policy engine that runs as an admission controller.

It can validate, mutate, generate, and verify Kubernetes resources.

In this lab, I installed Kyverno in a local Kind cluster using a Helm-rendered manifest. I generated the manifest without Helm hooks because applying hook resources directly with kubectl caused the controllers to scale to zero. I also used server-side apply because Kyverno CRDs are large and client-side apply can exceed Kubernetes annotation limits.

Then I created a ClusterPolicy in Enforce mode to block container images using the `latest` tag.

When I applied a Deployment using `nginx:latest`, Kyverno denied it through the admission webhook.

When I applied a Deployment using `nginx:1.27-alpine`, Kyverno allowed it and the Pod ran successfully.

This demonstrates how Kyverno can enforce DevSecOps guardrails directly inside Kubernetes before workloads are deployed.

---

## Lab Status

```text
Tool: Kyverno
Cluster: Kind
Install method: Helm-rendered manifest
Apply method: Server-side apply
Policy type: ClusterPolicy
Mode: Enforce
Bad deployment: Denied
Good deployment: Allowed
Status: Completed
```