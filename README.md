# Azure Cloud Resume Challenge

**WIP**

This is the beginning of a twist on the Cloud Resume Challenge that is using Kubernetes (AKS).

Currently, it does the following:

- Spins up an AKS Cluster
- Installs ArgoCD on that cluster
  - Points ArgoCD to monitor this repo, specifically the `argocd/` directory
- Sets up DNS for the `imkumpy.com` domain
- In the ArgoCD deployment, a simple nginx website is hosted
  - WIP, left off troubleshooting ingress issues
