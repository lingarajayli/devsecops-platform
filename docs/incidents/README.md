# Production Incident Notes

This directory contains production-style incident documentation for DevOps, DevSecOps, SRE, Platform Engineering, and Kubernetes troubleshooting practice.

Each incident follows a consistent structure:

- Scenario
- Meaning
- Request Flow
- Troubleshooting Map
- Common Causes
- Investigation
- Example Root Cause
- Remediation
- Prevention
- Interview Answer
- Follow-up Interview Questions
- LinkedIn Draft

---

## Kubernetes Core Incidents

| # | Incident | Focus Area |
|---|----------|------------|
| 001 | [502 Bad Gateway](001-502-bad-gateway.md) | Ingress, reverse proxy, backend connectivity |
| 002 | [CrashLoopBackOff](002-crashloopbackoff.md) | Container crashes, logs, restart behavior |
| 003 | [ImagePullBackOff](003-imagepullbackoff.md) | Image pull, registry, imagePullSecrets |
| 004 | [OOMKilled](004-oomkilled.md) | Memory limits, Linux OOM killer, resource tuning |
| 005 | [Pod Pending](005-pending-pod.md) | Scheduling, resources, taints, PVCs |
| 006 | [ContainerCreating Stuck](006-containercreating-stuck.md) | Kubelet, runtime, volumes, secrets, CNI |
| 007 | [CreateContainerConfigError](007-createcontainerconfigerror.md) | Missing Secrets, ConfigMaps, invalid config |
| 008 | [CreateContainerError](008-createcontainererror.md) | Runtime container creation failures |
| 009 | [Evicted Pod](009-evicted-pod.md) | Node pressure, eviction, QoS |
| 010 | [Node NotReady](010-node-notready.md) | Kubelet, runtime, node health |
| 011 | [DNS Resolution Failure](011-dns-resolution-failure.md) | CoreDNS, service discovery, networking |
| 012 | [Service Endpoints Empty](012-service-endpoints-empty.md) | Service selectors, labels, readiness |
| 013 | [Ingress 404 or 503](013-ingress-404-503.md) | Ingress routing, host/path, backend service |
| 014 | [Readiness Probe Failure](014-readiness-probe-failure.md) | Traffic routing, health checks, endpoints |
| 015 | [Liveness Probe Failure](015-liveness-probe-failure.md) | Container restarts, health checks, startupProbe |

---

## CI/CD and DevSecOps Incidents

| # | Incident | Focus Area |
|---|----------|------------|
| 016 | [GitHub Actions Pipeline Failure](016-github-actions-pipeline-failure.md) | CI/CD debugging, workflow logs |
| 017 | [Docker Image Vulnerability Found by Trivy](017-trivy-image-vulnerability.md) | Image scanning, CVEs, remediation |
| 018 | [Secret Leak Detected by Gitleaks](018-gitleaks-secret-detected.md) | Secret scanning, credential rotation |
| 019 | [SonarQube Quality Gate Failed](019-sonarqube-quality-gate-failed.md) | Code quality, coverage, security gates |
| 020 | [Failed Deployment Rollback](020-failed-deployment-rollback.md) | Rollbacks, deployment safety, release recovery |

---

## Observability and Production Incidents

| # | Incident | Focus Area |
|---|----------|------------|
| 021 | [High CPU Usage](021-high-cpu-usage.md) | CPU saturation, throttling, scaling |
| 022 | [High Memory Usage](022-high-memory-usage.md) | Memory leaks, cache growth, OOM risk |
| 023 | [Kubernetes Node Disk Pressure](023-disk-pressure.md) | Disk usage, ephemeral storage, node pressure |
| 024 | [Prometheus Target Down](024-prometheus-target-down.md) | Monitoring, scrape failures, ServiceMonitor |
| 025 | [Application Latency Spike](025-application-latency-spike.md) | Latency, bottlenecks, observability |

---

## How to Study These Incidents

Recommended study flow:

1. Read the Scenario and Meaning.
2. Understand the Request Flow.
3. Study the Troubleshooting Map.
4. Practice the Key Commands locally.
5. Memorize the Interview Answer.
6. Convert the LinkedIn Draft into a post.
7. Later, build a hands-on lab for selected incidents.

---

## Interview Preparation

For each incident, be ready to answer:

- What does this error mean?
- At which layer does the failure happen?
- What would you check first?
- Which command gives the strongest clue?
- What are common root causes?
- How would you fix it safely?
- How would you prevent recurrence?

---

## Portfolio Goal

This incident library is part of my DevSecOps platform portfolio.

The goal is to demonstrate practical troubleshooting knowledge across:

- Kubernetes
- Linux
- Networking
- CI/CD
- DevSecOps
- Observability
- Production incident response
- SRE-style debugging