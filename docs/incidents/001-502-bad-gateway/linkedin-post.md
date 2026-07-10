# LinkedIn Post: 502 Bad Gateway

Today I documented a production-style incident: `502 Bad Gateway`.

A 502 usually means the load balancer, reverse proxy, gateway, or ingress controller cannot get a valid response from the upstream backend service.

In a Kubernetes-based setup, I would check:

1. Ingress or NGINX logs
2. Backend pod status
3. Kubernetes Service endpoints
4. Readiness probes
5. Recent deployments
6. Service port and targetPort mapping

One common root cause:

The application listens on port `8080`, but the Kubernetes Service is configured with `targetPort: 8000`.

Key lesson:

Do not restart blindly.

Troubleshoot using evidence:

Observe → Hypothesize → Verify → Act

I’m documenting these production-style incidents as part of my DevSecOps platform portfolio.

GitHub repo:
https://github.com/lingarajayli/devsecops-platform

#DevOps #DevSecOps #Kubernetes #SRE #PlatformEngineering #Linux #CloudEngineering