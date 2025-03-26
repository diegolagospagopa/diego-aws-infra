# Creazione del ClusterRole
resource "kubernetes_cluster_role" "viewer" {
  metadata {
    name = "viewer"
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs      = ["get", "list", "watch"]
  }
}

# Creazione del ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "viewer_binding" {
  metadata {
    name = "my-viewer-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.viewer.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "my-viewer"
    api_group = "rbac.authorization.k8s.io"
  }
}
