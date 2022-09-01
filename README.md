<h1 align="center">
  <a href="https://github.com/ventx/terraform-aws-stackx-cluster">
    <!-- Please provide path to your logo here -->
    <img src="https://raw.githubusercontent.com/ventx/terraform-aws-stackx-cluster/main/docs/images/logo.svg" alt="Logo" width="100" height="100">
  </a>
</h1>

<div align="center">
  ventx/terraform-aws-stackx-cluster
  <br />
  <a href="#about"><strong>Explore the diagrams »</strong></a>
  <br />
  <br />
  <a href="https://github.com/ventx/terraform-aws-stackx-cluster/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/ventx/terraform-aws-stackx-cluster/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  ·
  <a href="https://github.com/ventx/terraform-aws-stackx-cluster/issues/new?assignees=&labels=question&template=04_SUPPORT_QUESTION.md&title=support%3A+">Ask a Question</a>
</div>

<div align="center">
<br />

[![Project license](https://img.shields.io/github/license/ventx/terraform-aws-stackx-cluster.svg?style=flat-square)](LICENSE)

[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/ventx/terraform-aws-stackx-cluster/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
[![code with love by ventx](https://img.shields.io/badge/%3C%2F%3E%20with%20♥%20by-ventx-blue)](https://github.com/ventx)

</div>

<details open>
<summary>Table of Contents</summary>

- [About](#about)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Quickstart](#quickstart)
- [Usage](#usage)
- [Support](#support)
- [Project assistance](#project-assistance)
- [Contributing](#contributing)
- [Authors & contributors](#authors--contributors)
- [Security](#security)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Roadmap](#roadmap)

</details>

---

## About

> Terraform cluster module which deploys a Kubernetes (EKS) cluster control-plane to AWS.
> Supports logs ingested to CloudWatch via KMS encryption.
> Deploys EKS Add-Ons "aws-vpc-cni" and "kube-proxy" with matching EKS control-plane version.
> Creates an IAM OIDC provider to be used with EKS IRSA authentication mechanism. -- Part of stackx.


<details>
<summary>ℹ️ Architecture Diagrams</summary>
<br>


|                                Placeholder                                 |                                                            Rover                                                            |
|:-------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://raw.githubusercontent.com/ventx/terraform-aws-stackx-cluster/main/docs/images/screenshot1.png" title="Placeholder" width="100%"> | <img src="https://raw.githubusercontent.com/ventx/terraform-aws-stackx-cluster/main/docs/images/screenshot2.png" title="Rover" width="100%"> |

</details>


### Built With

<no value>


## Getting Started

### Prerequisites


* AWS credentials
* Terraform
* [VPC network and subnets](https://github.com/ventx/stackx-terraform-aws-network)

### Quickstart

To get started, clone the projects, check all configurable [Inputs](#inputs) and deploy everything with `make`.

```shell
git clone https://github.com/ventx/stackx-terraform-aws-cluster.git
make all # init, validate, plan, apply
```



## Usage


You can run this module in conjunction with other stackx components (recommended) or as single-use (build your own).

Deployment time around: 12 minutes
```shell
  make apply  2.98s user 0.83s system 0% cpu 12:11.53 total
```

### stackx (RECOMMENDED)

This is just a bare minimum example of how to use the module.
See all available stackx modules here: https://github.com/ventx


```hcl
  module "aws-network" {
    source = "ventx/stackx-network/aws"
    version     = "0.1.0"
  }

  module "aws-cluster" {
    source          = "ventx/stackx-cluster/aws"
    version         = "0.1.0" // Pinned and tested version, generated by {x-release-please-version}
    cluster_version = "1.23"
    subnet_ids      = module.aws_network.private_subnet_ids
  }
```

### Single-Use

```hcl
  module "aws-cluster" {
    source = "ventx/stackx-cluster/aws"
    version     = "0.1.0" // Pinned and tested version, generated by {x-release-please-version}
    cluster_version = "1.22"
    subnet_ids = ["subnet-1", "subnet-2", "subnet-3"]
  }
```




## Terraform



### Features


* Simple and easy to use, just the bare minimum
* Control-Plan logs ingested to CloudWatch via KMS encryption
* EKS Add-Ons "aws-vpc-cni" and "kube-proxy"
* IAM OIDC provider to be used with EKS IRSA
* EKS Fargate Profile support (disabled by default)

### Resources


* EKS
* EKS Fargate Profile
* CloudWatch Log Group
* IAM OIDC provider
* IAM Policies
* IAM Roles
* SecurityGroup
* SecurityGroup rules
* KMS Key
* KMS Key Alias

### Opinions

Our Terraform modules are are highly opionated:

* Keep modules small, focused, simple and easy to understand
* Prefer simple code over complex code
* Prefer [KISS](https://en.wikipedia.org/wiki/KISS_principle) > [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
* Set some sane default values for variables, but do not set a default value if user input is strictly required


These opinions can be seen as some _"soft"_ rules but which are not strictly required.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_tag.cluster_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_iam_openid_connect_provider.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.vpc_cni_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_secrets_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_secrets_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group_rule.ingress_worker_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_cluster_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_addon_version.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.eks_secrets_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.fargate_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_cni_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.oidc](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_cw_retention"></a> [cluster\_cw\_retention](#input\_cluster\_cw\_retention) | Specifies the number of days you want to retain log events in the log group for EKS Cluster events (e.g. `90` => 90 days) | `number` | `1` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | Add additional tags to the EKS created main/primary cluster Security Group - will be merged with `var.tags` and Karpenter discovery tag | `map(string)` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes master major version (e.g. `1.21`) (https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) | `string` | `"1.23"` | no |
| <a name="input_cw_kms_arn"></a> [cw\_kms\_arn](#input\_cw\_kms\_arn) | KMS Key ARN for CloudWatch encryption - if not set, your EKS control plane logs will be ingested unencrypted | `string` | `""` | no |
| <a name="input_eks_api_access_cidrs"></a> [eks\_api\_access\_cidrs](#input\_eks\_api\_access\_cidrs) | IP CIDRs which are allowed to access the EKS API Public endpoint) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | Log types to enable for EKS Cluster (Master) - Valid values: `api`, `audit`, `authenticator`, `controllerManager`, `scheduler` | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_eks_kms_admin_arns"></a> [eks\_kms\_admin\_arns](#input\_eks\_kms\_admin\_arns) | Additional ARNs to be added in EKS KMS Key Policy for administrative access (default: current context) | `list(string)` | `[]` | no |
| <a name="input_eks_kms_arn"></a> [eks\_kms\_arn](#input\_eks\_kms\_arn) | KMS Key ARN for EKS secrets encryption-at-rest | `string` | `null` | no |
| <a name="input_eks_kms_key_deletion_window"></a> [eks\_kms\_key\_deletion\_window](#input\_eks\_kms\_key\_deletion\_window) | The waiting period, specified in number of days (between `7` and `30`), until the AWS KMS Key will be finally deleted. | `number` | `7` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Enable / Disable private EKS API endpoint | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Enable / Disable private EKS API endpoint | `bool` | `true` | no |
| <a name="input_fargate"></a> [fargate](#input\_fargate) | Enable / Disable use of Fargate profile | `bool` | `false` | no |
| <a name="input_fargate_iam_role_arn"></a> [fargate\_iam\_role\_arn](#input\_fargate\_iam\_role\_arn) | Existing IAM Role ARN to be used for Fargate Execution Role | `string` | `""` | no |
| <a name="input_fargate_selectors"></a> [fargate\_selectors](#input\_fargate\_selectors) | List of selector for Kubernetes Pods to execute with the Fargate Profile (Default to a K8s Namespace: `fargate`) | `any` | <pre>[<br>  {<br>    "namespace": "fargate"<br>  }<br>]</pre> | no |
| <a name="input_ip_family"></a> [ip\_family](#input\_ip\_family) | IP Family for EKS cluster - `ipv4` or `ipv6` | `string` | `"ipv4"` | no |
| <a name="input_name"></a> [name](#input\_name) | Base Name for all resources (preferably generated by terraform-null-label) | `string` | `"stackx-cluster"` | no |
| <a name="input_static_unique_id"></a> [static\_unique\_id](#input\_static\_unique\_id) | Static unique ID, defined in the root module once, to be suffixed to all resources for uniqueness (if you choose uuid / longer id, some resources will be cut of at max length - empty means disable and NOT add unique suffix) | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs to create EKS Cluster into | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | User specific Tags / Labels to attach to resources (will be merged with module tags) | `map(string)` | `{}` | no |
| <a name="input_tf_eks_cluster_timeouts"></a> [tf\_eks\_cluster\_timeouts](#input\_tf\_eks\_cluster\_timeouts) | (Optional) Updated Terraform resource management timeouts. Applies to `aws_eks_cluster` in particular to permit resource management times | `map(string)` | <pre>{<br>  "create": "30m",<br>  "delete": "15m",<br>  "update": "60m"<br>}</pre> | no |
| <a name="input_tf_eks_fargate_profile_timeouts"></a> [tf\_eks\_fargate\_profile\_timeouts](#input\_tf\_eks\_fargate\_profile\_timeouts) | (Optional) Updated Terraform resource management timeouts. Applies to `aws_eks_fargate_profile` in particular to permit resource management times | `map(string)` | <pre>{<br>  "create": "5m",<br>  "delete": "10m"<br>}</pre> | no |
| <a name="input_worker_sg_id"></a> [worker\_sg\_id](#input\_worker\_sg\_id) | SecurityGroup ID of Worker nodes | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_cidrs"></a> [api\_cidrs](#output\_api\_cidrs) | EKS Public API endpoint allowed CIDRs |
| <a name="output_cluster_ca"></a> [cluster\_ca](#output\_cluster\_ca) | EKS Cluster certificate authority |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS Cluster endpoint |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS Cluster name |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | ARN of the EKS cluster IAM role |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | EKS Cluster K8s Version |
| <a name="output_eni_sg_ids"></a> [eni\_sg\_ids](#output\_eni\_sg\_ids) | EKS Cluster cross-account ENIs Security Group IDs |
| <a name="output_k8s_version"></a> [k8s\_version](#output\_k8s\_version) | EKS Cluster K8s Version |
| <a name="output_oidc_issuer"></a> [oidc\_issuer](#output\_oidc\_issuer) | Issuer URL of EKS Cluster OIDC |
| <a name="output_oidc_issuer_arn"></a> [oidc\_issuer\_arn](#output\_oidc\_issuer\_arn) | OIDC Identity issuer ARN for the EKS cluster (IRSA) |
| <a name="output_platform_version"></a> [platform\_version](#output\_platform\_version) | EKS Cluster Platform Version |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | EKS Cluster Security Group ID created by Amazon EKS |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | EKS Cluster VPC ID |
<!-- END_TF_DOCS -->



## Support

If you need professional support directly by the maintainers of the project, don't hesitate to contact us:
<a href="https://www.ventx.de/kontakt.html">
  <img align="center" src="https://i.imgur.com/OoCRUwz.png" alt="ventx Contact Us Kontakt" />
</a>

- [GitHub issues](https://github.com/ventx/terraform-aws-stackx-cluster/issues/new?assignees=&labels=question&template=04_SUPPORT_QUESTION.md&title=support%3A+)
- Contact options listed on [this GitHub profile](https://github.com/hajowieland)


## Project assistance

If you want to say **thank you** or/and support active development of terraform-aws-stackx-cluster:

- Add a [GitHub Star](https://github.com/ventx/terraform-aws-stackx-cluster) to the project.
- Tweet about the terraform-aws-stackx-cluster.
- Write interesting articles about the project on [Dev.to](https://dev.to/), [Medium](https://medium.com/) or your personal blog.

Together, we can make terraform-aws-stackx-cluster **better**!




## Contributing

First off, thanks for taking the time to contribute! Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please read [our contribution guidelines](.github/CONTRIBUTING.md), and thank you for being involved!


## Security

terraform-aws-stackx-cluster follows good practices of security, but 100% security cannot be assured.
terraform-aws-stackx-cluster is provided **"as is"** without any **warranty**. Use at your own risk.

_For more information and to report security issues, please refer to our [security documentation](.github/SECURITY.md)._


## License

This project is licensed under the **Apache 2.0 license**.

See [LICENSE](LICENSE) for more information.


## Acknowledgements

* All open source contributors who made this possible


## Roadmap

See the [open issues](https://github.com/ventx/terraform-aws-stackx-cluster/issues) for a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/ventx/terraform-aws-stackx-cluster/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/ventx/terraform-aws-stackx-cluster/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/ventx/terraform-aws-stackx-cluster/issues?q=is%3Aopen+is%3Aissue+label%3Abug)


