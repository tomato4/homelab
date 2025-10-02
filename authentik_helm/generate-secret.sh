#! /bin/bash

kubectl create secret generic authentik-secrets \
  --from-literal=AUTHENTIK_POSTGRESQL__PASSWORD="$(openssl rand -base64 32)" \
  --from-literal=AUTHENTIK_SECRET_KEY="$(openssl rand -base64 32)" \
  --namespace authentik \
  --dry-run=client -o yaml > secrets/secret.yaml

kubeseal --controller-namespace kube-system \
  --format yaml < secrets/secret.yaml > templates/sealed-secret.yaml
