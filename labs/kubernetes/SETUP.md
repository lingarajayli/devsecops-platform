# Kubernetes Lab Setup

This guide prepares the local Kubernetes environment for all incident labs.

The chosen lab environment is:

```text
Docker + Kind + kubectl
```

Kind runs Kubernetes nodes as Docker containers, so Docker must be installed and running before creating a cluster.

---

## Tools Required

| Tool | Purpose |
|---|---|
| Docker | Runs Kind Kubernetes nodes as containers |
| Kind | Creates local Kubernetes clusters |
| kubectl | Interacts with Kubernetes clusters |

---

## 1. Verify Docker

Check Docker:

```bash
docker version
docker ps
```

If Docker is not running, start Docker first.

On Linux:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Optional: allow current user to run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Verify again:

```bash
docker ps
```

---

## 2. Install kubectl

`kubectl` is the Kubernetes CLI used to interact with the cluster.

Kubernetes recommends using a `kubectl` version within one minor version of the cluster version.

### Linux x86_64

Download latest stable `kubectl`:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install it:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Verify:

```bash
kubectl version --client
```

---

## 3. Install Kind

Kind is used to create a local Kubernetes cluster using Docker containers as nodes.

### Linux x86_64

Download Kind:

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.32.0/kind-linux-amd64
```

Make it executable:

```bash
chmod +x ./kind
```

Move it to PATH:

```bash
sudo mv ./kind /usr/local/bin/kind
```

Verify:

```bash
kind version
```

---

## 4. Create Kind Cluster

Create the lab cluster:

```bash
kind create cluster --name devsecops-lab
```

Verify cluster access:

```bash
kubectl cluster-info --context kind-devsecops-lab
kubectl get nodes
kubectl get pods -A
```

Expected result:

```text
The node should show Ready status.
```

---

## 5. Create Lab Namespace

All Kubernetes incident labs will use this namespace:

```bash
kubectl create namespace incident-labs
```

Verify:

```bash
kubectl get namespaces
```

---

## 6. Useful Cluster Commands

List Kind clusters:

```bash
kind get clusters
```

Delete the lab cluster:

```bash
kind delete cluster --name devsecops-lab
```

Recreate the lab cluster:

```bash
kind create cluster --name devsecops-lab
```

Switch context:

```bash
kubectl config use-context kind-devsecops-lab
```

Check current context:

```bash
kubectl config current-context
```

---

## 7. Troubleshooting Setup Issues

### Docker permission denied

Error:

```text
permission denied while trying to connect to the Docker daemon socket
```

Fix:

```bash
sudo usermod -aG docker $USER
newgrp docker
docker ps
```

### Kind command not found

Check:

```bash
which kind
```

Fix:

```bash
sudo mv ./kind /usr/local/bin/kind
kind version
```

### kubectl command not found

Check:

```bash
which kubectl
```

Fix:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

### Cluster already exists

Error:

```text
node(s) already exist for a cluster with the name devsecops-lab
```

Fix:

```bash
kind delete cluster --name devsecops-lab
kind create cluster --name devsecops-lab
```

---

## 8. Cleanup

Delete namespace only:

```bash
kubectl delete namespace incident-labs
```

Delete entire Kind cluster:

```bash
kind delete cluster --name devsecops-lab
```

---

## References

- Kind Quick Start
- Kubernetes kubectl installation guide