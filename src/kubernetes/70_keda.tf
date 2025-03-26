# # Create IAM role for KEDA
# resource "aws_iam_role" "keda_role" {
#   name = "eks-keda-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Principal = {
#           Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}"
#         }
#         Condition = {
#           StringLike = {
#             "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" : "system:serviceaccount:keda:keda-operator"
#           }
#         }
#       }
#     ]
#   })

#   tags = var.tags
# }

# # Attach policies to the KEDA role
# resource "aws_iam_role_policy" "keda_policy" {
#   name = "eks-keda-policy"
#   role = aws_iam_role.keda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "sqs:GetQueueAttributes",
#           "sqs:GetQueueUrl",
#           "sqs:ListQueues",
#           "sqs:ListQueueTags",
#           "sqs:ReceiveMessage",
#           "cloudwatch:GetMetricData",
#           "cloudwatch:GetMetricStatistics",
#           "cloudwatch:ListMetrics"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "helm_release" "keda" {
#   name             = "keda"
#   repository       = "https://kedacore.github.io/charts"
#   chart            = "keda"
#   namespace        = "keda"
#   create_namespace = true
#   version          = "2.16.1"  # Latest stable version as of now

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.keda_role.arn
#   }
# }
