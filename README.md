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

flux create image repository mystok-gcp-flux-prod \                        ─╯
--image=dekabitasp/mystok-gcp-app-prod \
--interval=1m \
--export > ./clusters/my-cluster/mystok-gcp-flux-prod-registry.yaml

flux create image policy mystok-gcp-flux-prod \                                                                                                             ─╯
--image-ref=mystok-gcp-flux-prod \
--interval=1m \
--semver=5.0.x \
--export > ./clusters/my-cluster/mystok-gcp-flux-prod-policy.yaml    
