resource "helm_release" "external_nginx" {
  name = "external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = "4.12.0"

  values = [file("${path.module}/k8s/nginx-ingress.yaml")]

  depends_on = [helm_release.aws_lbc]
}
