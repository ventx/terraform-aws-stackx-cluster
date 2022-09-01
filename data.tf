# --------------------------------------------------------------------------
# Locals - Data Sources
# --------------------------------------------------------------------------
# Get the current AWS region name
data "aws_region" "current" {}


# Get the current effective AWS account ID
data "aws_caller_identity" "current" {}

# Get EKS token to modify aws-auth ConfigMap
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}

# Get the current context to add in KMS policy
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

# Get the current AWS partition (aws, aws-cn, aws-us-gov)
data "aws_partition" "current" {}
