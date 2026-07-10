# LinkedIn Post: 502 Bad Gateway

Today I documented a production-style incident: `502 Bad Gateway`.

A 502 usually means the load balancer, reverse proxy, gateway, or ingress controller cannot get a valid response from the upstream backend service.

My troubleshooting approach:

1. Confirm scope and impact
2. Check monitoring for 5xx errors
3. Check load balancer or ingress health
4. Review NGINX/reverse proxy logs
5. Check backend application health
6. Verify service endpoints
7. Check recent deployments or config changes
8. Apply the safest fix
9. Monitor recovery

Key lesson:

Do not restart blindly.

Troubleshoot using evidence:

Observe → Hypothesize → Verify → Act

This is part of my DevSecOps platform portfolio where I’m documenting real production-style incidents, runbooks, and troubleshooting approaches.