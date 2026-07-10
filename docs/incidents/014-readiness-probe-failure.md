# Incident #014: Kubernetes Readiness Probe Failure

## Scenario

A production workload shows the following incident:

```text
Kubernetes Readiness Probe Failure
```

Impact: users may experience failed requests, slow responses, failed deployments, or unavailable services.

---

## Meaning

The container is running, but Kubernetes does not consider it ready to receive traffic.

Important point:

Do not guess the root cause. Start from observable evidence: events, logs, metrics, configuration, and recent changes.

---

## Request Flow

```mermaid
flowchart TD
    A[Issue detected]
    B[Collect symptoms]
    C[Check logs metrics and events]
    D[Identify probable root cause]
    E[Apply safest remediation]
    F[Verify recovery]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
```

---

## Troubleshooting Map

```mermaid
flowchart TD
    A["Kubernetes Readiness Probe Failure"]

    A --> B["Meaning<br/>The container is running, but Kubernetes does not consider it ready to receive traffic"]

    B --> C["Common Causes<br/>Wrong health path<br/>Wrong port<br/>App slow startup<br/>Dependency unavailable<br/>Timeout too low"]

    C --> D["Investigation<br/>kubectl describe pod<br/>Check readiness probe config<br/>Curl health endpoint<br/>Check app logs<br/>Check service endpoints"]

    D --> E["Remediation<br/>Fix probe path/port/timing or application health behavior, then verify Service endpoints."]

    E --> F["Prevention<br/>Add monitoring and alerts<br/>Validate in CI/CD<br/>Document rollback steps<br/>Review production changes"]
```

---

## Common Causes

- Wrong health path
- Wrong port
- App slow startup
- Dependency unavailable
- Timeout too low
- Health endpoint returns non-200

---

## Investigation

### Goal

Identify the safest and most likely root cause using evidence.

### Investigation Flow

1. Confirm scope and impact.
2. Check recent deployments or configuration changes.
3. Check events, logs, and metrics.
4. Identify the failing layer.
5. Apply the safest remediation.
6. Verify recovery.
7. Document the incident.

### Key Commands

```bash
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl get nodes
kubectl describe node <node-name>
```

For CI/CD incidents:

```bash
git status
git log --oneline -5
git diff HEAD~1
```

### Evidence to Collect

- Incident start time
- Affected service
- Error message
- Recent deployment or config change
- Logs
- Metrics
- Events
- Current version
- Previous known-good version
- Remediation applied

---

## Example Root Cause

Readiness probe checked `/healthz`, but the application exposed `/health`.

---

## Remediation

Fix probe path/port/timing or application health behavior, then verify Service endpoints.

Verify recovery:

```bash
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp
```

---

## Prevention

- Add monitoring and alerting
- Add CI/CD validation
- Review configuration changes carefully
- Keep rollback steps documented
- Add post-deployment smoke tests
- Keep runbooks updated
- Use production change reviews

---

## Interview Answer

`Kubernetes Readiness Probe Failure` means the container is running, but Kubernetes does not consider it ready to receive traffic.

I would confirm the impact, check recent changes, inspect events/logs/metrics, identify the failing layer, apply the safest remediation, and verify recovery. I would avoid random restarts and troubleshoot using evidence.

---

## Follow-up Interview Questions

- How would you confirm the root cause?
- What logs, metrics, or events would you check first?
- How would you prevent this from happening again?
- When would you roll back?
- What would you document after recovery?

---

## LinkedIn Draft

Today I documented production-style incident #014: Kubernetes Readiness Probe Failure.

Key lesson:

Troubleshooting should be evidence-based, not guess-based.

My investigation flow:

1. Confirm impact
2. Check recent changes
3. Check logs, metrics, and events
4. Identify the failing layer
5. Apply the safest fix
6. Verify recovery

GitHub repo:
https://github.com/lingarajayli/devsecops-platform

#DevOps #DevSecOps #SRE #PlatformEngineering #Kubernetes #CICD
