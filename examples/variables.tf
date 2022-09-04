variable "tags" {
  default = {
    "owner"     = "terraform-aws-terratest",
    "managedby" = "terratest",
    "project"   = "stackx",
    "workspace" = "terratest"
  }
}

variable "tag_cluster_sg" {
  default = true
}

variable "enable_addon_kube_proxy" {
  default = true
}

variable "enable_addon_vpc_cni" {
  default = true
}

variable "workspace_name" {
  default = "terratest"
}

variable "cluster_name" {
  default = "stackx"
}
