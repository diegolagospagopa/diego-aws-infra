resource "aws_iam_user" "developer" {
  name = "developer"
}

# Questa policy IAM permette all'utente di:
# - Visualizzare i dettagli dei cluster EKS (DescribeCluster)
# - Elencare tutti i cluster EKS disponibili (ListClusters)
# Queste autorizzazioni sono necessarie per consentire all'utente di connettersi e interagire con i cluster EKS
resource "aws_iam_policy" "developer_eks" {
  name = "AmazonEKSDeveloperPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "developer_eks" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks.arn
}

# Questo blocco di codice crea un punto di accesso (access entry) per EKS che:
# - Associa l'utente IAM "developer" al cluster EKS specificato
# - Mappa l'ARN dell'utente IAM AWS al gruppo Kubernetes "my-viewer"
# - Il gruppo "my-viewer" ha i permessi definiti nel ClusterRoleBinding precedente,
#   che consente operazioni di sola lettura (get, list, watch) su risorse specifiche
resource "aws_eks_access_entry" "developer" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.developer.arn
  kubernetes_groups = ["my-viewer"]
}
