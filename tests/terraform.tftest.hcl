provider "aws" {
  region = "us-east-1"
}

run "execute" {

  # Deploy networking + cluster defined in tests subdir

  module {
    source = "./tests"
  }

  assert {
    condition     = module.network.vpc_cidr == "10.1.0.0/16"
    error_message = "VPC CIDR did not match expected"
  }

  assert {
    condition     = module.network.private_subnets == 3
    error_message = "Private Subnet count did not match expected"
  }

  assert {
    condition     = module.cluster.cluster_name == "stackx-cluster-f2f6c971-6a3c-4d"
    error_message = "Cluster name did not match expected"
  }

  assert {
    condition     = module.cluster.cluster_version == "1.27"
    error_message = "Cluster version did not match expected"
  }
}
