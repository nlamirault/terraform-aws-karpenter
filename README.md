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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
