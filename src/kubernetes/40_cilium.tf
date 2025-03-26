
resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  namespace  = "kube-system"
  version    = "1.15.4"

  set {
    name  = "ipam.mode"
    value = "cluster-pool"
  }

  set {
    name  = "tunnel"
    value = "vxlan"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "strict"
  }

  set {
    name  = "k8sServiceHost"
    value = aws_eks_cluster.eks.endpoint
  }

  set {
    name  = "k8sServicePort"
    value = "443"
  }

  set {
    name  = "securityContext.privileged"
    value = "true"
  }

  depends_on = [aws_eks_node_group.main_node]
}
