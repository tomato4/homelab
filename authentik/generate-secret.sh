#! /bin/bash

kubectl create secret generic authentik-secrets \
  --from-literal=authentik-postgresql="$(openssl rand -base64 32)" \
  --from-literal=authentik-secret="$(openssl rand -base64 32)" \
  --namespace authentik \
  --dry-run=client -o yaml > secrets/secret.yaml

kubeseal --controller-name kube-system \
  --format yaml < secrets/secret.yaml > secrets/sealed-secret.yaml
