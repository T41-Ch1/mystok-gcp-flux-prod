# mystok-gcp-flux-prod

flux bootstrap github \                                                                                                                                     ─╯
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=mystok-gcp-flux-prod \
  --branch=main \
  --path=clusters/my-cluster \
  --token-auth \
  --personal

