variable "name" {
  description = "Base Name for all resources (preferably generated by terraform-null-label)"
  type        = string
  default     = "stackx-cluster"
}

variable "tags" {
  description = "User specific Tags / Labels to attach to resources (will be merged with module tags)"
  type        = map(string)
  default     = {}
}

variable "cluster_tags" {
  description = "Add additional tags to the EKS created main/primary cluster Security Group - will be merged with `var.tags` and Karpenter discovery tag"
  type        = map(string)
  default     = {}
}

# EKS Custer version
variable "cluster_version" {
  description = "Kubernetes master major version (e.g. `1.28`) (https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)"
  type        = string
  default     = "1.27"
  validation {
    condition     = contains(["1.24", "1.25", "1.26", "1.27", "1.28"], var.cluster_version)
    error_message = "The selected EKS Kubernetes version is not valid - please check: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html ."
  }
}

variable "eks_cluster_log_types" {
  description = "Log types to enable for EKS Cluster (Master) - Valid values: `api`, `audit`, `authenticator`, `controllerManager`, `scheduler`"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "ip_family" {
  description = "IP Family for EKS cluster - `ipv4` or `ipv6`"
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "ipv6"], var.ip_family)
    error_message = "The selected IP family is not valid, please choose one of: `ipv4` or `ipv6`."
  }
}

# EKS API Public access
variable "eks_api_access_cidrs" {
  description = "IP CIDRs which are allowed to access the EKS API Public endpoint)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # for initial setup
}

variable "eks_kms_arn" {
  description = "KMS Key ARN for EKS secrets encryption-at-rest"
  type        = string
  default     = null
}

variable "eks_kms_admin_arns" {
  description = "Additional ARNs to be added in EKS KMS Key Policy for administrative access (default: current context)"
  type        = list(string)
  default     = []
}

variable "eks_kms_key_deletion_window" {
  description = "The waiting period, specified in number of days (between `7` and `30`), until the AWS KMS Key will be finally deleted."
  type        = number
  default     = 7
  validation {
    condition = (
      var.eks_kms_key_deletion_window >= 7 &&
      var.eks_kms_key_deletion_window <= 30
    )
    error_message = "KMS Key deletion windows needs to be between 7 and 30 days."
  }
}

variable "endpoint_public_access" {
  description = "Enable / Disable private EKS API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable / Disable private EKS API endpoint"
  type        = bool
  default     = true
}

# CloudWatch
variable "cw_kms_arn" {
  description = "KMS Key ARN for CloudWatch encryption - if not set, your EKS control plane logs will be ingested unencrypted"
  type        = string
  default     = ""
}

variable "cluster_cw_retention" {
  description = "Specifies the number of days you want to retain log events in the log group for EKS Cluster events (e.g. `90` => 90 days)"
  type        = number
  default     = 1
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cluster_cw_retention)
    error_message = "AWS Region you selected is invalid or not enabled."
  }
}

# EKS Worker stuff
variable "worker_sg_id" {
  description = "SecurityGroup ID of Worker nodes"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs to create EKS Cluster into"
  type        = list(string)
}

variable "tag_cluster_sg" {
  description = "Add tags to EKS created Cluster Security Group"
  type        = bool
  default     = true
}

# EKS Addons
variable "enable_addon_kube_proxy" {
  description = "Enable / Disable EKS Addon `kube-proxy`"
  type        = bool
  default     = true
}

variable "enable_addon_vpc_cni" {
  description = "Enable / Disable EKS Addon `vpc-cni`"
  type        = bool
  default     = true
}

# Fargate
variable "fargate" {
  description = "Enable / Disable use of Fargate profile"
  type        = bool
  default     = false
}

variable "fargate_iam_role_arn" {
  description = "Existing IAM Role ARN to be used for Fargate Execution Role"
  type        = string
  default     = ""
}

variable "fargate_selectors" {
  description = "List of selector for Kubernetes Pods to execute with the Fargate Profile (Default to a K8s Namespace: `fargate`)"
  type        = any
  default = [{
    namespace = "fargate"
  }]
}

# Sane Timeouts
variable "tf_eks_cluster_timeouts" {
  description = "(Optional) Updated Terraform resource management timeouts. Applies to `aws_eks_cluster` in particular to permit resource management times"
  type        = map(string)
  default = {
    create = "30m"
    update = "60m"
    delete = "15m"
  }
}

variable "tf_eks_fargate_profile_timeouts" {
  description = "(Optional) Updated Terraform resource management timeouts. Applies to `aws_eks_fargate_profile` in particular to permit resource management times"
  type        = map(string)
  default = {
    create = "5m"
    delete = "10m"
  }
}
