# Incident #008: CreateContainerError

## Scenario

A production workload shows the following incident:

```text
CreateContainerError
```

Impact: users may experience failed requests, slow responses, failed deployments, or unavailable services.

---

## Meaning

Kubernetes scheduled the pod, but the container runtime failed while creating the container.

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
    A["CreateContainerError"]

    A --> B["Meaning<br/>Kubernetes scheduled the pod, but the container runtime failed while creating the container"]

    B --> C["Common Causes<br/>Invalid container command<br/>Invalid container args<br/>Wrong working directory<br/>Volume mount permission issue<br/>SecurityContext conflict"]

    C --> D["Investigation<br/>kubectl describe pod<br/>Check Events section<br/>Check command and args<br/>Check volume mounts<br/>Check SecurityContext"]

    D --> E["Remediation<br/>Fix invalid command, args, mount permissions, or runtime issue, then restart the rollout."]

    E --> F["Prevention<br/>Add monitoring and alerts<br/>Validate in CI/CD<br/>Document rollback steps<br/>Review production changes"]
```

---

## Common Causes

- Invalid container command
- Invalid container args
- Wrong working directory
- Volume mount permission issue
- SecurityContext conflict
- Container runtime issue

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

The pod command points to `/app/start.sh`, but the file is missing or not executable.

---

## Remediation

Fix invalid command, args, mount permissions, or runtime issue, then restart the rollout.

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

`CreateContainerError` means kubernetes scheduled the pod, but the container runtime failed while creating the container.

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

Today I documented production-style incident #008: CreateContainerError.

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
