# Investigation: 502 Bad Gateway

## Goal

Find why the proxy/gateway cannot get a valid response from the backend service.

---

## Investigation Flow

1. Confirm user impact.
2. Check 5xx error rate.
3. Check proxy or ingress logs.
4. Check backend service health.
5. Verify service endpoints.
6. Check recent deployment changes.

---

## Key Commands

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get endpoints -A
kubectl logs <pod-name> -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
```

---

## Evidence to Collect

- Error start time
- Affected endpoint
- Proxy or ingress error logs
- Backend pod status
- Service endpoint status
- Recent deployment or config change

---

## Example Finding

The backend pod is running, but the Kubernetes Service is forwarding traffic to the wrong `targetPort`.

---

## Investigation Principle

Collect evidence before changing system state.