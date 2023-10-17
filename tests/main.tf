module "cluster" {
  source = "../"

  cluster_version  = "1.27"
  static_unique_id = "f2f6c971-6a3c-4d6e-9dca-7a3ba454d64d" # just random uuid generated for testing cut offs etc
  subnet_ids       = module.network.private_subnet_ids

  tags = var.tags
}

module "network" {
  source  = "ventx/stackx-network/aws"
  version = "0.2.1"

  name           = "terratest-all-0-network"
  workspace_name = "terratest"
  cluster_name   = "test"
  tags           = var.tags

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
