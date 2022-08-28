data "aws_iam_policy_document" "eks_secrets_encryption" {
  count = var.eks_kms_arn == null ? 1 : 0

  statement {
    sid    = "Allow access for all principals in the account that are authorized"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["eks.${data.aws_region.current.name}.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow direct access to key metadata to the account"
    effect = "Allow"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:RevokeGrant",
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = concat(
        var.eks_kms_admin_arns,
        [data.aws_iam_session_context.current.issuer_arn]
      )
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_cluster.arn
      ]
    }
  }

  # Permission to allow AWS services that are integrated with AWS KMS to use the CMK,
  # particularly services that use grants.
  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_cluster.arn
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "eks_secrets_encryption" {
  count = var.eks_kms_arn == null ? 1 : 0

  description             = "AWS KMS key for encrypting and decrypting EKS secrets at-rest"
  deletion_window_in_days = var.eks_kms_key_deletion_window
  key_usage               = "ENCRYPT_DECRYPT"
  is_enabled              = true
  enable_key_rotation     = true

  policy = join("", data.aws_iam_policy_document.eks_secrets_encryption[*].json)

  tags = local.tags
}

resource "aws_kms_alias" "eks_secrets_encryption" {
  count = var.eks_kms_arn == null ? 1 : 0

  name          = "alias/${local.cluster_name}"
  target_key_id = join("", aws_kms_key.eks_secrets_encryption[*].key_id)
}
