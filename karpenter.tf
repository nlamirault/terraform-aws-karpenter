# Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SPDX-License-Identifier: Apache-2.0

module "irsa_karpenter" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.3.0"

  create_role                   = true
  role_name                     = "Karpenter"
  provider_url                  = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.service_account}"]

  tags = merge(
    { "Name" = local.role_name },
    local.tags
  )
}

resource "aws_iam_policy" "controller" {
  name        = local.service_name
  description = "Policy for Karpenter"

  #tfsec:ignore:AWS099
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = merge(
    { "Name" = local.role_name },
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "controller" {
  role       = module.irsa_karpenter.iam_role_name
  policy_arn = aws_iam_policy.controller.arn
}

resource "aws_iam_role" "node" {
  name        = format("%s-node", local.service_name)
  description = "Permissions for Karpenter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.eks_worker_node.arn,
    data.aws_iam_policy.eks_cni_policy.arn,
    data.aws_iam_policy.ecr_read_only.arn,
    data.aws_iam_policy.ssm_managed_instance.arn
  ]

  tags = merge(
    { "Name" = local.role_name },
    local.tags
  )
}
