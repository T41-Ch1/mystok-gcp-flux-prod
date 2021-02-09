#!/bin/bash
gcloud compute url-maps import web-map-http-prod --source ./gcloud/web-map-http-prod.yaml --global
gcloud compute target-http-proxies create http-lb-proxy-prod --url-map=web-map-http-prod --global
gcloud compute forwarding-rules create http-content-rule-prod --address=mystok-gcp-ip-prod --global --target-http-proxy=http-lb-proxy-prod --ports=80

