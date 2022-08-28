output "k8s_version" {
  description = "EKS Cluster K8s Version"
  value       = aws_eks_cluster.cluster.version
}

output "platform_version" {
  description = "EKS Cluster Platform Version"
  value       = aws_eks_cluster.cluster.platform_version
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca" {
  description = "EKS Cluster certificate authority"
  value       = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_eks_cluster.cluster.role_arn
}

output "api_cidrs" {
  description = "EKS Public API endpoint allowed CIDRs"
  value       = aws_eks_cluster.cluster.vpc_config.0.public_access_cidrs
}

output "eni_sg_ids" {
  description = "EKS Cluster cross-account ENIs Security Group IDs"
  value       = aws_eks_cluster.cluster.vpc_config.0.security_group_ids
}

output "sg_id" {
  description = "EKS Cluster Security Group ID created by Amazon EKS"
  value       = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
}

output "oidc_issuer" {
  description = "Issuer URL of EKS Cluster OIDC"
  value       = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "oidc_issuer_arn" {
  description = "OIDC Identity issuer ARN for the EKS cluster (IRSA)"
  value       = join("", aws_iam_openid_connect_provider.irsa.*.arn)
}
