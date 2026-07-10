# Interview Notes: 502 Bad Gateway

## Question

What does `502 Bad Gateway` mean and how would you troubleshoot it?

## Short Answer

A `502 Bad Gateway` means the gateway, reverse proxy, load balancer, or ingress controller could not get a valid response from the upstream backend service.

## Senior Troubleshooting Flow

1. Confirm scope and impact.
2. Check monitoring for 5xx errors.
3. Check load balancer or ingress health.
4. Review NGINX or reverse proxy logs.
5. Check backend health.
6. Verify service endpoints.
7. Check recent deployments or config changes.
8. Fix safely and monitor recovery.

## Strong Interview Answer

A 502 Bad Gateway usually means the proxy or gateway layer is reachable, but it cannot get a valid response from the backend service. I would first confirm the scope and impact, then check monitoring for 5xx spikes. Next, I would inspect load balancer or ingress health, review NGINX/reverse proxy logs, and check backend application health. In Kubernetes, I would verify pods, services, endpoints, readiness probes, ingress configuration, and recent rollout history. I would avoid blind restarts and troubleshoot layer by layer using evidence.

## Follow-up Questions

- Difference between 502, 503, and 504?
- How do you check Kubernetes service endpoints?
- What NGINX log errors indicate upstream failure?
- How would you prevent this in CI/CD?