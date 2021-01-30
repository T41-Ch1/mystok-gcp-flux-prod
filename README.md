# mystok-gcp-flux-prod
起動手順:

1.
kubesec decrypt kubesec-prod-mystok-gcp-sealedsecret-cert.yaml | k apply -f -

2.
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.6/controller.yaml

3.
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=mystok-gcp-flux-prod \
  --branch=main \
  --path=clusters/my-cluster \
  --token-auth \
  --personal
(作成時のみ)
flux create image repository mystok-gcp-flux-prod \                        ─╯
--image=dekabitasp/mystok-gcp-app-prod \
--interval=1m \
--export > ./clusters/my-cluster/mystok-gcp-flux-prod-registry.yaml

(作成時のみ)
flux create image policy mystok-gcp-flux-prod \                                                                                                             ─╯
--image-ref=mystok-gcp-flux-prod \
--interval=1m \
--semver=5.0.x \
--export > ./clusters/my-cluster/mystok-gcp-flux-prod-policy.yaml    

3.
gcloud compute backend-services update k8s-be-31942--4739945ebad3cc4a --session-affinity=CLIENT_IP --global

4.
gcloud compute backend-services update k8s1-4739945e-default-mystok-app-80-34f883e2 --session-affinity=CLIENT_IP --global

