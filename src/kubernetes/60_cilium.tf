# Cilium installation with Helm
resource "helm_release" "cilium" {
  name             = "cilium"
  namespace        = "kube-system"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  version          = "1.15.1"
  create_namespace = false

  set {
    name  = "cluster.name"
    value = aws_eks_cluster.core.name
  }

  set {
    name  = "eni.enabled"
    value = "false"
  }

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "tunnel"
    value = "vxlan"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "disabled"
  }

  set {
    name  = "k8sServiceHost"
    value = aws_eks_cluster.core.endpoint
  }

  set {
    name  = "k8sServicePort"
    value = "443"
  }

  depends_on = [aws_eks_cluster.core]
}
