# Karpenter

Terraform module which configure Karpenter resources on Amazon AWS

## Usage

```hcl
module "karpenter" {
  source  = "nlamirault/karpenter/aws"
  version = "x.y.z"

  cluster_name = var.cluster_name

  namespace       = var.namespace
  service_account = var.service_account

  tags = var.tags
}
```

and variables :

```hcl
cluster_name = "foo-staging-eks"

namespace       = "karpenter-system"
service_account = "provider-aws"

tags = {
    "project" = "foo"
    "env"     = "staging"
    "service" = "karpenter"
    "made-by" = "terraform"
}
```

## Documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.27.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa_karpenter"></a> [irsa\_karpenter](#module\_irsa\_karpenter) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_node_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_node_group_name"></a> [cluster\_node\_group\_name](#input\_cluster\_node\_group\_name) | Node Group name for Karpenter | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace | `string` | `"kube-system"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The Kubernetes service account | `string` | `"karpenter"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for AWS resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Amazon Resource Name for Karpenter |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
