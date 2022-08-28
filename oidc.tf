# --------------------------------------------------------------------------
# OpenID COnnect Provider (OIDC)
# --------------------------------------------------------------------------
# For IRSA: https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "irsa" {
  client_id_list  = ["sts.amazonaws.com"]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  thumbprint_list = [data.tls_certificate.oidc.certificates.0.sha1_fingerprint]

  tags = local.tags
}
