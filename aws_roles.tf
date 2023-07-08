data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
  name = var.clusterName
}

data "aws_iam_policy_document" "crossplane_permission_policy_document" {
  count     = var.createRoleforAWSProvider ? 1 : 0

  statement {
    not_actions = [ "iam:*", "organizations:*", "account:*", "cloudtrail:*" ]
    effect      = "Allow"
    resources   = [ "*" ]
  }

  statement {
    effect    = "Allow"
    actions   = [ "ecr:*", "sns:Subscribe" ]
    resources = [ "*" ]
  }

  statement {
    effect    = "Deny"
    actions   = [ "iam:*" ]
    resources = [ "*" ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/restricted"
      values   = [ "true" ]
    }

  }

  statement {
    effect    = "Deny"
    actions   = [ "iam:*" ]
    resources = [ "arn:aws:iam::*:role/*role-adm*" ]
  }

  statement {
    effect    = "Allow"
    actions   = [ "iam:CreateRole", "iam:CreateUser" ]
    resources = [ "*" ]

    condition {
      test = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/policy-iam-boundary" ]
    }
  }

  statement {
    actions   = [
      "account:ListRegions",
      "cloudtrail:Get*",
      "cloudtrail:Describe*",
      "cloudtrail:List*",
      "cloudtrail:LookupEvents",
      "iam:Get*",
      "iam:List*",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
      "iam:Simulate*",
      "organizations:DescribeOrganization",
      "organizations:DescribeAccount",
      "iam:Add*",
      "iam:Update*",
      "iam:Attach*",
      "iam:Detach*",
      "iam:Delete*",
      "iam:Remove*",
      "iam:Put*",
      "iam:Untag*",
      "iam:Tag*",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:UpdateRoleDescription",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:CreateServiceLinkedRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:DeleteServiceLinkedRole",
      "iam:DetachGroupPolicy",
      "iam:PutGroupPolicy",
      "iam:AttachGroupPolicy",
      "iam:DeleteGroupPolicy",
      "iam:DeleteGroup",
      "iam:UpdateGroup",
      "iam:CreateGroup",
      "iam:*OpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:UpdateServiceSpecificCredential",
      "iam:ResetServiceSpecificCredential",
      "iam:DeleteServiceSpecificCredential",
      "iam:CreateServiceSpecificCredential",
      "iam:DeleteUser",
      "iam:PutUserPolicy",
      "iam:DetachUserPolicy",
      "iam:UpdateUser",
      "iam:DeleteUserPolicy",
      "iam:AttachUserPolicy",
      "iam:AddUserToGroup",
      "iam:RemoveUserFromGroup",
      "iam:CreatePolicy",
      "iam:SetDefaultPolicyVersion",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:CreatePolicyVersion",
      "iam:PassRole"
    ]

    effect    = "Allow"
    resources = [ "*" ]
  }

  statement {
    resources = [ "*" ]
    actions   = [
      "directconnect:*",
      "ec2:CreateNatGateway",
      "ec2:CreateVpn*",
      "ec2:DeleteVpn*",
      "ec2:ModifyVpn*",
      "ec2:DetachVpn*",
      "ec2:CreateTransit*",
      "ec2:DeleteTransit*",
      "ec2:ModifyTransit*",
      "groundstation:*",
      "guardduty:*",
      "outposts:*",
      "ram:*",
      "iam:*AccessKey",
      "iam:*AccessKeys",
      "snowball:*",
      "ec2:AuthorizeClientVpnIngress"
    ]
    effect    = "Deny" 
  }

}

module "iam_assumable_role_admin" {
  count                         = var.createRoleforAWSProvider ? 1 : 0

  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  role_permissions_boundary_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/policy-iam-boundary"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "role-crossplane-provider-aws"
  provider_url                  = replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.crossplane_permission_policy[count.index].arn]
  oidc_subjects_with_wildcards = ["system:serviceaccount:${var.crossplaneNamespace}:*"]
}

resource "aws_iam_policy" "crossplane_permission_policy" {
  count     = var.createRoleforAWSProvider ? 1 : 0
  
  policy    = data.aws_iam_policy_document.crossplane_permission_policy_document[count.index].json
  path      = "/"
  name      = "crossplane-provider-aws-permissions-policy"
}