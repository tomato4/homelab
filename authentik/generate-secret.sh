#! /bin/bash

mkdir -p secrets
echo "secret.yaml" > secrets/.gitignore

kubectl create secret generic authentik-secrets \
  --from-literal=POSTGRESQL_PASSWORD="$(openssl rand -base64 32)" \
  --from-literal=SECRET_KEY="$(openssl rand -base64 32)" \
  --namespace authentik \
  --dry-run=client -o yaml > secrets/secret.yaml

kubeseal --controller-namespace kube-system \
  --format yaml < secrets/secret.yaml > templates/sealed-secret.yaml
