# Kubernetes Incident Labs

This directory contains hands-on Kubernetes troubleshooting labs.

The goal is to convert production-style incident notes into practical local labs that can be reproduced, debugged, fixed, and documented.

These labs are designed for:

- DevOps Engineers
- DevSecOps Engineers
- SREs
- Platform Engineers
- Kubernetes interview preparation
- GitHub portfolio proof

---

## Setup Guide

Before running any lab, complete the setup guide:

```text
labs/kubernetes/SETUP.md

## Why These Labs Matter

Reading incident notes builds understanding.

Reproducing incidents builds real troubleshooting skill.

In production, engineers are expected to:

1. Understand the symptom
2. Identify the failing layer
3. Use the correct command
4. Read events and logs
5. Find the root cause
6. Apply the safest fix
7. Verify recovery
8. Document the incident

These labs are built around that same flow.

---

## Chosen Lab Environment

For this portfolio, the preferred Kubernetes lab environment is **Kind**.

Kind runs Kubernetes clusters using Docker containers as nodes. This keeps the setup lightweight, local-first, reproducible, and free.

For cloud learning, AWS and Azure concepts will be practiced using **Floci running in Docker**, so cloud workflows can be simulated locally before using real cloud accounts.

Real cloud accounts will be used only when explicitly required.

---

## Tools

| Tool | Purpose |
|---|---|
| Docker | Base runtime for Kind and local cloud labs |
| Kind | Local Kubernetes cluster |
| kubectl | Kubernetes CLI |
| Helm | Kubernetes package management |
| Floci | Local AWS/Azure-style cloud lab environment in Docker |
| GitHub Actions | CI validation |
| Trivy | Image vulnerability scanning |
| Gitleaks | Secret scanning |
| Semgrep | Static security scanning |
| Prometheus | Metrics and monitoring |
| Grafana | Dashboards |

---

## Kubernetes Setup

Create the Kind cluster:

```bash
kind create cluster --name devsecops-lab
```

Verify the cluster:

```bash
kubectl cluster-info --context kind-devsecops-lab
kubectl get nodes
kubectl get pods -A
```

Expected result:

```text
The cluster should have at least one Ready node.
```

---

## Lab List

| Lab | Incident | Focus Area | Status |
|---|---|---|---|
| 001 | CrashLoopBackOff | App crash, logs, restart count | Completed |
| 002 | ImagePullBackOff | Wrong image, registry failure | Completed |
| 003 | OOMKilled | Memory limits, OOM killer | Completed |
| 004 | Pod Pending | Scheduling, resources, taints | Completed |
| 005 | Service Endpoints Empty | Selectors, labels, readiness | Completed |
| 006 | Readiness Probe Failure | Health checks, traffic routing | Completed |
| 007 | Ingress 404/503 | Ingress routing, services, endpoints | Completed |

---

## Standard Lab Structure

Each lab follows this folder pattern:

```text
labs/kubernetes/<lab-name>/
├── README.md
├── broken/
│   └── manifests.yaml
├── fixed/
│   └── manifests.yaml
└── evidence/
    └── .gitkeep
```

Example:

```text
labs/kubernetes/001-crashloopbackoff/
├── README.md
├── broken/
│   └── deployment.yaml
├── fixed/
│   └── deployment.yaml
└── evidence/
    └── .gitkeep
```

---

## Standard Lab Flow

Each lab should be practiced like a real production incident.

### 1. Deploy Broken Manifest

```bash
kubectl apply -f broken/
```

### 2. Observe the Problem

```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl get events --sort-by=.lastTimestamp
```

### 3. Investigate

Use the correct commands based on the incident.

Examples:

```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl get pod <pod-name> -o yaml
kubectl describe deployment <deployment-name>
```

### 4. Fix the Issue

```bash
kubectl apply -f fixed/
```

### 5. Verify Recovery

```bash
kubectl get pods
kubectl get events --sort-by=.lastTimestamp
kubectl logs <pod-name>
```

### 6. Document Evidence

Store screenshots, command outputs, or notes under:

```text
evidence/
```

---

## Troubleshooting Rules

Always follow these rules:

1. Do not randomly delete pods first.
2. Do not blindly restart workloads.
3. Start with `kubectl get`.
4. Then use `kubectl describe`.
5. Read the Events section carefully.
6. Use logs only when the container has started.
7. Compare broken and fixed manifests.
8. Verify after remediation.
9. Document the root cause.

---

## Interview Value

After completing these labs, you should be able to explain:

- What the incident means
- Why it happens
- Which command gives the strongest clue
- What the root cause was
- How you fixed it
- How you would prevent it in production

---

## Priority Order

Recommended order:

1. CrashLoopBackOff
2. ImagePullBackOff
3. OOMKilled
4. Pod Pending
5. Service Endpoints Empty
6. Readiness Probe Failure
7. Ingress 404/503

This order builds troubleshooting skill from simple to advanced.

---

## Portfolio Goal

These labs prove that I can troubleshoot Kubernetes incidents hands-on, not just write theoretical notes.

Each lab will include:

- Broken manifest
- Fixed manifest
- Root cause explanation
- Investigation commands
- Evidence
- Interview answer
- Prevention steps

---

## Cloud Lab Direction

Kubernetes labs will use **Kind**.

AWS and Azure labs will use **Floci in Docker** where possible.

This keeps the portfolio:

- Free
- Local-first
- Reproducible
- Safe from accidental cloud billing
- Suitable for GitHub demonstration