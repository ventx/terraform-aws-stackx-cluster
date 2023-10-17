module "stackx-cluster" {
  source = "../"

  cluster_version  = "1.27"
  static_unique_id = "f2f6c971-6a3c-4d6e-9dca-7a3ba454d64d" # just random uuid generated for testing cut offs etc
  subnet_ids       = module.stackx-network.private_subnet_ids

  tag_cluster_sg          = var.tag_cluster_sg
  enable_addon_kube_proxy = var.enable_addon_kube_proxy
  enable_addon_vpc_cni    = var.enable_addon_vpc_cni

  tags = {
    examples = "example"
  }
}

module "stackx-network" {
  source  = "ventx/stackx-network/aws"
  version = "0.2.1"

  name           = "stackx-0-network"
  workspace_name = var.workspace_name
  cluster_name   = var.cluster_name
  tags = {
    test     = true,
    deleteme = true
  }

  # VPC
  single_nat_gateway = true

  # Private Subnets
  private = true
  private_subnet_tags = merge(
    var.tags,
    {
      "Access" = "private"
    }
  )

  # Public Subnets
  public = true
  public_subnet_tags = merge(
    var.tags,
    {
      "Access" = "public"
    }
  )
}
