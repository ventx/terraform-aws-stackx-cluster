# Changelog

## [0.2.0](https://github.com/ventx/terraform-aws-stackx-cluster/compare/v0.1.0...v0.2.0) (2022-09-08)


### Features

* add conditional for tagging the EKS-created Cluster Security Group (e.g. for Karpenter, etc.) ([7bd0bed](https://github.com/ventx/terraform-aws-stackx-cluster/commit/7bd0bed0ab8f755e2bf8980dbc0caa379627a280))
* add conditionals and TF Vars to enable vpc-cni and kube-proxy EKS Add-Ons one by one ([3add345](https://github.com/ventx/terraform-aws-stackx-cluster/commit/3add345c0115342930856286121325682c4aff20))

## 0.1.0 (2022-09-01)


### Features

* add partitition data source for support of gov and china regions ([2cac1d1](https://github.com/ventx/terraform-aws-stackx-cluster/commit/2cac1d159d897a26e27440647113427016525824))
* add support for EKS Fargate Profile and EKS Addons for kube-proxy, aws-vpc-cni (latter will be removed as we will manage it otherwise with more flexibility to set ENI PREFIX DELEGATION etc) ([355265b](https://github.com/ventx/terraform-aws-stackx-cluster/commit/355265b6bd0d6976adbef0d652d29c71ab078083))
* Initial commit 🚀 ([2968c6f](https://github.com/ventx/terraform-aws-stackx-cluster/commit/2968c6f5c1eb126cb93692757fd7b2e95267e267))
* output vpc_id of EKS cluster and cluster version to help with other modules ([c2e6cb6](https://github.com/ventx/terraform-aws-stackx-cluster/commit/c2e6cb6f06adeecc9f660a43727d27054f074e60))


### Bug Fixes

* added missing 'AmazonEKSVPCResourceController' IAM Policy to cluster IAM Role ([4b0d9b9](https://github.com/ventx/terraform-aws-stackx-cluster/commit/4b0d9b9f1c9710e8783ebcf2b5756459e5ad0875))
