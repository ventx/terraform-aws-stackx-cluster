# Tagging
locals {
  cluster_name = substr(lower("${var.name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"), 0, 31)
  cluster_tags = merge(
    var.tags,
    var.cluster_tags,
    {
      "karpenter.sh/discovery" = local.cluster_name
    }
  )
  log_group_name = substr(lower("${local.cluster_name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"), 0, 82)
  tags = merge(
    var.tags,
    {
      "Module" = "terraform-aws-stackx-cluster"
      "Github" = "https://github.com/ventx/terraform-aws-stackx-cluster"
    }
  )
}



resource "aws_cloudwatch_log_group" "eks_cluster" {
  # 1-512 chars
  # Log group names consist of the following characters: a-z, A-Z, 0-9, '_' (underscore), '-' (hyphen), '/' (forward slash), '.' (period), and '#' (number sign).
  name              = "/aws/eks/${local.log_group_name}/cluster"
  retention_in_days = var.cluster_cw_retention
  kms_key_id        = var.cw_kms_arn != "" ? var.cw_kms_arn : null

  tags = local.tags
}

# --------------------------------------------------------------------------
# EKS Cluster "Control Plane"
# --------------------------------------------------------------------------
resource "aws_eks_cluster" "cluster" {
  # ^[0-9A-Za-z][A-Za-z0-9\-_]+$
  # 1-100 chars
  # localstack k3s limitation: Cluster name must be <= 32 characters
  name                      = local.cluster_name
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = var.eks_cluster_log_types #tfsec:ignore:aws-eks-enable-control-plane-logging
  version                   = var.cluster_version

  encryption_config {
    provider {
      key_arn = var.eks_kms_arn == null ? join("", aws_kms_key.eks_secrets_encryption[*].arn) : var.eks_kms_arn
    }
    resources = ["secrets"]
  }

  kubernetes_network_config {
    ip_family         = var.ip_family
    service_ipv4_cidr = "172.16.0.0/12"
  }

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    # initially set to true, to configure aws-auth ConfigMap from TF Cloud - can be disabled later in root module
    endpoint_public_access = var.endpoint_public_access #tfsec:ignore:aws-eks-no-public-cluster-access
    public_access_cidrs    = var.eks_api_access_cidrs   #tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
    //security_group_ids     = [var.worker_sg_id]       // only needed for Unmanaged Node Groups - Managed Node Groups get automatically added by EKS
    subnet_ids = flatten([var.subnet_ids])
  }

  tags = local.tags

  timeouts {
    create = lookup(var.tf_eks_cluster_timeouts, "create", null)
    delete = lookup(var.tf_eks_cluster_timeouts, "delete", null)
    update = lookup(var.tf_eks_cluster_timeouts, "update", null)
  }

  # CloudWatch has to be setup first to set the Retention period - otherwise EKS creates this with unlimited retention
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.attach
  ]

  lifecycle {
    ignore_changes = [
      vpc_config.0.endpoint_public_access,
      vpc_config.0.public_access_cidrs
    ]
  }
}


# --------------------------------------------------------------------------
# Add tags to the EKS created main/primary cluster security group
# --------------------------------------------------------------------------
resource "aws_ec2_tag" "cluster_security_group" {
  for_each = { for k, v in merge(local.tags, local.cluster_tags) : k => v if var.tag_cluster_sg }

  resource_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}

# --------------------------------------------------------------------------
# Security Group rules
# --------------------------------------------------------------------------
resource "aws_security_group_rule" "ingress_worker_cluster" {
  count = var.worker_sg_id != null ? 1 : 0

  description              = "Allow EKS worker Kubelets and pods to receive communication from cluster control plane"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = var.worker_sg_id
  source_security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  to_port                  = 65535
  type                     = "ingress"

  depends_on = [aws_eks_cluster.cluster]
}

resource "aws_security_group_rule" "worker_cluster_ingress" {
  count = var.worker_sg_id != null ? 1 : 0

  description              = "Allow EKS workers to communicate with cluster"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.worker_sg_id
  to_port                  = 65535
  type                     = "ingress"

  depends_on = [aws_eks_cluster.cluster]
}
