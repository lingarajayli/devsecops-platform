# Remediation: 502 Bad Gateway

## Immediate Fix

Identify the failing layer between the proxy/gateway and backend application.

Common immediate actions:

- Fix wrong upstream host or port
- Restart failed backend service only after checking logs
- Roll back faulty deployment
- Correct Kubernetes Service `targetPort`
- Restore healthy backend targets
- Fix NGINX or Ingress configuration

## Validation

After applying the fix:

```bash
curl -I http://application-url
kubectl get endpoints -n <namespace>
kubectl get pods -n <namespace>
```

## Rollback

If the issue started after a deployment:

```bash
kubectl rollout undo deployment/<deployment-name> -n <namespace>
```

## Long-Term Prevention

- Add readiness probes
- Add post-deployment smoke tests
- Validate Kubernetes manifests in CI
- Monitor ingress 5xx errors
- Alert when backend endpoints become unhealthy
- Document service ports clearly