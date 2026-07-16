# Falco Runtime Security Detection Summary

## Objective

This report documents how Falco was used to detect suspicious runtime activity inside a Kubernetes workload running on a local Kind cluster.

The goal was to move beyond pre-deployment scanning and policy enforcement into runtime security monitoring.

---

## Why Falco?

Previous tools in this lab series focused on pre-deployment security:

| Tool | Purpose |
|---|---|
| kube-score | Kubernetes production-readiness scanning |
| Trivy config | Kubernetes misconfiguration scanning |
| Kubescape | Kubernetes security posture scanning |
| Kyverno | Kubernetes admission policy enforcement |

Falco is different because it detects suspicious activity while workloads are running.

---

## Runtime Security Scenario

A normal Nginx Pod was deployed:

```text
falco-test-nginx
```

Image used:

```text
nginx:1.27-alpine
```

Then suspicious activity was triggered manually:

```bash
kubectl exec -it falco-test-nginx -- sh
cat /etc/shadow
```

---

## Falco Installation Method

Falco was installed into a local Kind cluster using a Helm-rendered manifest.

The manifest was generated with:

```bash
helm template falco falcosecurity/falco \
  --namespace falco \
  --values labs/security/kubernetes-scanning/falco/install/values.yaml \
  --no-hooks \
  > labs/security/kubernetes-scanning/falco/install/falco-generated.yaml
```

It was applied using:

```bash
kubectl apply --server-side \
  -f labs/security/kubernetes-scanning/falco/install/falco-generated.yaml
```

---

## Falco Runtime Status

Falco was deployed as a DaemonSet:

```text
falco   1 desired   1 current   1 ready
```

Falco Pod status:

```text
falco   2/2 Running
```

This is expected because Falco runs one Pod per node to observe runtime activity.

---

## Driver and Event Source

Falco successfully started with:

```text
Falco version: 0.44.1
Event source: syscall
Driver: modern BPF probe
Kernel: WSL2 Linux kernel
```

This confirms Falco was able to observe Linux syscall activity in the local Kind environment.

---

## Alert 1: Shell Spawned in Container

Falco detected an interactive shell inside the container:

```text
Notice A shell was spawned in a container with an attached terminal
process=sh
container_name=nginx
container_image_repository=docker.io/library/nginx
container_image_tag=1.27-alpine
k8s_pod_name=falco-test-nginx
k8s_ns_name=default
```

Why this matters:

```text
Interactive shell access inside a container can indicate debugging, misconfiguration, compromised access, or attacker activity.
```

---

## Alert 2: Sensitive File Read

Falco detected reading `/etc/shadow`:

```text
Warning Sensitive file opened for reading by non-trusted program
file=/etc/shadow
process=cat
command=cat /etc/shadow
container_name=nginx
k8s_pod_name=falco-test-nginx
k8s_ns_name=default
```

Why this matters:

```text
Reading sensitive files inside a container can indicate credential discovery or privilege abuse.
```

---

## Before vs After

| Stage | Activity | Falco Result |
|---|---|---|
| Normal Pod running | Nginx container started | No suspicious alert required |
| Runtime shell access | `kubectl exec -it ... -- sh` | Alert generated |
| Sensitive file read | `cat /etc/shadow` | Alert generated |

---

## Key Learning

Falco detects runtime behavior, not just manifest configuration.

A Kubernetes workload can pass image scanning, manifest scanning, and admission policy checks, but still show suspicious behavior at runtime.

Falco fills that runtime security gap.

---

## DevSecOps Value

Falco helps detect:

```text
Shell opened inside a container
Sensitive file access
Unexpected process execution
Package manager execution inside containers
Privilege escalation behavior
Container escape indicators
Suspicious network tool usage
Unexpected writes to sensitive paths
```

---

## Production Best Practices

```text
Run Falco as a DaemonSet
Send Falco alerts to a central system
Integrate Falco with SIEM or alerting tools
Tune noisy rules
Document accepted exceptions
Treat shell access in containers as suspicious
Correlate Falco alerts with Kubernetes audit logs
Use Falco alongside admission control and image scanning
```

---

## Interview Explanation

Falco is a runtime security tool for Kubernetes and Linux.

It watches syscall activity and detects suspicious behavior while containers are running.

In this lab, I installed Falco on a local Kind cluster using a Helm-rendered manifest.

Falco ran as a DaemonSet and successfully used the modern BPF probe on WSL2.

I deployed an Nginx test Pod, opened an interactive shell inside it using `kubectl exec`, and then attempted to read `/etc/shadow`.

Falco generated alerts for both suspicious activities: a shell spawned inside a container and a sensitive file being opened for reading.

This demonstrates runtime threat detection, which complements pre-deployment scanning tools like Trivy, kube-score, Kubescape, and enforcement tools like Kyverno.

---

## Lab Status

```text
Tool: Falco
Cluster: Kind
Install method: Helm-rendered manifest
Runtime driver: modern BPF probe
Event source: syscall
Test workload: nginx:1.27-alpine
Runtime test 1: Shell inside container
Runtime test 2: Sensitive file read
Status: Completed
```