# --------------------------------------------------------------------------
# IAM Role
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "tr" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  // expected length of name to be in the range (1 - 64)
  name               = substr(lower(trimspace(("eks-cluster-${local.cluster_name}"))), 0, 63)
  assume_role_policy = data.aws_iam_policy_document.tr.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = toset(["AmazonEKSClusterPolicy", "AmazonEKSServicePolicy", "AmazonEKSVPCResourceController"])
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/${each.key}"
  role       = aws_iam_role.eks_cluster.name
}
