# Incident #001: 502 Bad Gateway

## Scenario

Users report that the application is unavailable and the browser shows:

```text
502 Bad Gateway

```

## Meaning

A `502 Bad Gateway` means the reverse proxy, load balancer, gateway, or ingress controller could not get a valid response from the upstream backend service.

```text
Client
  ↓
Load Balancer / Reverse Proxy / Ingress
  ↓
Backend Application
```

The client can reach the proxy layer, but the proxy cannot successfully reach or receive a valid response from the backend.

## Common Causes

- Backend application is down
- Wrong upstream host or port
- NGINX or Ingress misconfiguration
- Kubernetes Service has no healthy endpoints
- Pod is crashing or not ready
- Load balancer target is unhealthy
- Firewall, Security Group, NACL, or NetworkPolicy is blocking traffic
- TLS mismatch between proxy and backend
- Backend timeout or connection refused

## Troubleshooting Steps

1. Confirm scope and impact.
2. Check monitoring for 5xx errors.
3. Check load balancer or ingress health.
4. Check NGINX or reverse proxy logs.
5. Check backend application health.
6. Check connectivity from proxy to backend.
7. Check recent deployments or configuration changes.
8. Apply the safest fix.
9. Monitor recovery.

## Useful Commands

### NGINX

```bash
sudo nginx -t
sudo systemctl status nginx
sudo journalctl -u nginx --since "30 minutes ago"
sudo tail -n 100 /var/log/nginx/error.log
```

### Docker

```bash
docker ps
docker logs <container_name>
```

### Kubernetes

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get endpoints -A
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
```

## Example Root Cause

The application container listens on port `8080`, but the Kubernetes Service is configured with `targetPort: 8000`.

Because of this mismatch, the ingress can reach the Service, but traffic does not reach the application correctly.

## Remediation

Fix the Service port mapping:

```yaml
ports:
  - port: 80
    targetPort: 8080
```

Verify:

```bash
kubectl get endpoints -n <namespace>
curl -I http://application-url
```

## Prevention

- Add readiness probes
- Validate Kubernetes manifests in CI
- Add smoke tests after deployment
- Monitor ingress 5xx errors
- Alert on unhealthy targets
- Review service ports during deployment reviews
- Document rollback steps

## Interview Answer

A `502 Bad Gateway` usually means the gateway, reverse proxy, load balancer, or ingress controller could not get a valid response from the upstream backend. I would check monitoring, proxy logs, backend health, service endpoints, and recent deployments. In Kubernetes, I would verify pods, services, endpoints, ingress, readiness probes, and rollout history. I would avoid blind restarts and troubleshoot layer by layer using evidence.

## Key Takeaway

A 502 usually points to a problem between the proxy/gateway layer and the backend application.