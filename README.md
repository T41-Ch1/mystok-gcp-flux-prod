# mystok-gcp-flux-prod
起動手順:

前回のHTTPリダイレクト用のLoadBalancerが削除されているか確認

mcrtとNEGが貯まりすぎてないか確認=>削除

※prodとdevの起動を同時並行で行うとバグる
1.(startup.sh)
kubesec decrypt kubesec-prod-mystok-gcp-sealedsecret-cert.yaml | k apply -f -

2.(startup.sh)
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.6/controller.yaml

3.(startup.sh)
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=mystok-gcp-flux-prod \
  --branch=main \
  --path=clusters/my-cluster \
  --token-auth \
  --personal

(作成時のみ)
flux create kustomization mystok-gcp-flux-prod \\n  --source=flux-system \\n  --path="." \\n  --prune=true \\n  --validation=client \\n  --interval=5m \\n  --export > ./clusters/my-cluster/mystok-gcp-flux-prod-kustomization.yaml

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

You should modify manifest to disable semver and enable alphabetical order

3.
gcloud compute backend-services update k8s-be-31942--4739945ebad3cc4a --session-affinity=CLIENT_IP --global

4.
gcloud compute backend-services update k8s1-4739945e-default-mystok-app-80-34f883e2 --session-affinity=CLIENT_IP --global

5.(httpRedirect.sh)
gcloud compute url-maps import web-map-http-prod --source ./gcloud/web-map-http-prod.yaml --global

6.(httpRedirect.sh)
 gcloud compute target-http-proxies create http-lb-proxy-prod --url-map=web-map-http-prod --global

7.(httpRedirect.sh)
gcloud compute forwarding-rules create http-content-rule-prod --address=mystok-gcp-ip-prod --global --target-http-proxy=http-lb-proxy-prod --ports=80

8.
gcloud consoleで操作(Prefix_Redirect => Full_Path_Redirect)

※Httpsリダイレクト用のLoadBalancerは毎回terraformとは別に削除しないとアカン
####################
To Delete All mcrt

gcloud compute ssl-certificates delete `gcloud compute ssl-certificates list | awk '{print $1}' | awk 'NR%2!=1'`
