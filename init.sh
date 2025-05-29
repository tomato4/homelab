#!/usr/bin/env bash

# K3s
curl -sfL https://get.k3s.io | sh -

# ArgoCD
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl apply -f argocd-ingress.yml
sudo kubectl apply -f argocd-disable-internal-tls.yml

# Nginx
#sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/cloud/deploy.yaml

# Metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml

# Cert
mkcert -cert-file server.pem -key-file server-key.pem "*.server.local"
kubectl create secret tls homelab-tls \
  --namespace kube-system \
  --cert=homelab.pem \
  --key=homelab-key.pem

# VPN
kubectl create secret generic windscribe-auth \
  --namespace=media \
  --from-file=ovpn=Windscribe-Prague-Vltava.ovpn \
  --from-file=auth.txt=auth.txt \
  --from-literal=username="$(head -n 1 auth.txt)" \
  --from-literal=password="$(tail -n 1 auth.txt)"

# Tailscale
kubectl create secret generic tailscale-auth \
  -n tailscale \
  --from-literal=tsAuthKey=""
