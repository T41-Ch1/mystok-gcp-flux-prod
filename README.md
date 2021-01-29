# mystok-gcp-flux-prod

kubesec decrypt kubesec-prod-mystok-gcp-sealedsecret-cert.yaml | k apply -f -
kubesec decrypt kubesec-dev-mystok-gcp-sealedsecret-cert.yaml | k apply -f -

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.6/controller.yaml

flux bootstrap github \                                                                                                                                     ─╯
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=mystok-gcp-flux-prod \
  --branch=main \
  --path=clusters/my-cluster \
  --token-auth \
  --personal

