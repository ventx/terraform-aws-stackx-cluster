# --------------------------------------------------------------------------
# AWS VPC CNI
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# IAM Policy for IPv6 AWS VPC CNI
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "vpc_cni_ipv6" {
  count = var.enable_addon_vpc_cni && var.ip_family == "ipv6" ? 1 : 0

  statement {
    sid = "AssignDescribe"
    actions = [
      "ec2:AssignIpv6Addresses",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "CreateTags"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:${data.aws_partition.current.partition}:ec2:*:*:network-interface/*"]
  }
}

resource "aws_iam_policy" "vpc_cni_ipv6" {
  count = var.enable_addon_vpc_cni && var.ip_family == "ipv6" ? 1 : 0

  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
  # max. 128 characters
  name = substr(lower("AmazonEKS_CNI_IPv6_Policy-${local.cluster_name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"), 0, 127)

  description = "IAM policy for EKS CNI to assign IPV6 addresses"
  policy      = data.aws_iam_policy_document.vpc_cni_ipv6.0.json

  tags = local.tags
}

data "aws_iam_policy_document" "vpc_cni" {
  count = var.enable_addon_vpc_cni ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.irsa.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.irsa.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "vpc_cni" {
  count = var.enable_addon_vpc_cni ? 1 : 0

  // expected length of name to be in the range (1 - 64)
  name = substr(lower(trimspace(("AmazonEKS_CNI_Role-${local.cluster_name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"))), 0, 63)

  assume_role_policy = data.aws_iam_policy_document.vpc_cni.0.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "example" {
  count = var.enable_addon_vpc_cni ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.0.name
}


data "aws_eks_addon_version" "vpc_cni" {
  count = var.enable_addon_vpc_cni ? 1 : 0

  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "vpc_cni" {
  count = var.enable_addon_vpc_cni ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = data.aws_eks_addon_version.vpc_cni.0.version
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.vpc_cni.0.arn

  tags = local.tags
}


# --------------------------------------------------------------------------
# kube-proxy
# --------------------------------------------------------------------------
data "aws_eks_addon_version" "kube_proxy" {
  count = var.enable_addon_kube_proxy ? 1 : 0

  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.enable_addon_kube_proxy ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = data.aws_eks_addon_version.kube_proxy.0.version
  resolve_conflicts_on_create = "OVERWRITE"

  tags = local.tags
}
