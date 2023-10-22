module "cluster" {
  source = "../"

  cluster_version = "1.27"
  subnet_ids      = module.network.private_subnet_ids

  tags = var.tags
}

module "network" {
  source  = "ventx/stackx-network/aws"
  version = "0.2.3"

  name         = "terratest-all-0-network"
  cluster_name = "test"
  tags         = var.tags

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
