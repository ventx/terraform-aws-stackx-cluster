################################################################################
# Fargate Profile
################################################################################
resource "aws_eks_fargate_profile" "this" {
  count = var.fargate ? 1 : 0

  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = var.name
  pod_execution_role_arn = var.fargate_iam_role_arn == "" ? aws_iam_role.fargate[0].arn : var.fargate_iam_role_arn
  subnet_ids             = var.subnet_ids

  dynamic "selector" {
    for_each = var.fargate_selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
  }

  timeouts {
    create = lookup(var.tf_eks_fargate_profile_timeouts, "create", null)
    delete = lookup(var.tf_eks_fargate_profile_timeouts, "delete", null)
  }

  tags = local.tags
}


################################################################################
# IAM Role
################################################################################

data "aws_iam_policy_document" "fargate_assume_role_policy" {
  count = var.fargate && var.fargate_iam_role_arn == "" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate" {
  count = var.fargate && var.fargate_iam_role_arn == "" ? 1 : 0

  // expected length of name to be in the range (1 - 64)
  name        = substr(lower(trimspace(("eks-fargate-${local.cluster_name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"))), 0, 63)
  description = "EKS Fargate Profile for ${local.cluster_name}"

  assume_role_policy    = data.aws_iam_policy_document.fargate_assume_role_policy[0].json
  force_detach_policies = true

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.fargate && var.fargate_iam_role_arn == "" ? 1 : 0

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate[0].name
}
