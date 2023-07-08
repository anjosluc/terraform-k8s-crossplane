# Terraform Module Crossplane Deployment on Kubernetes

![Crossplane Icon](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMlJxOgwpRPCgrsSz0wLzhmWnSJgpy6tOjEUOQiU-e7ZClZ_n-JqxP1SbBi3hHMaEeDa0&usqp=CAU)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.59.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.38.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.7.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 3.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.crossplane_permission_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.crossplane_install](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.controller_config_aws](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.provider](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.crossplane_permission_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusterName"></a> [clusterName](#input\_clusterName) | n/a | `string` | n/a | yes |
| <a name="input_configurationPackages"></a> [configurationPackages](#input\_configurationPackages) | n/a | `list(string)` | `[]` | no |
| <a name="input_createRoleforAWSProvider"></a> [createRoleforAWSProvider](#input\_createRoleforAWSProvider) | n/a | `bool` | `true` | no |
| <a name="input_crossplaneNamespace"></a> [crossplaneNamespace](#input\_crossplaneNamespace) | n/a | `string` | `"crossplane-system"` | no |
| <a name="input_imageRepository"></a> [imageRepository](#input\_imageRepository) | n/a | `string` | `"harbor.example.com/docker-hub/crossplane/crossplane"` | no |
| <a name="input_providerPackages"></a> [providerPackages](#input\_providerPackages) | n/a | `list(string)` | `[]` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | n/a | `number` | `1` | no |
| <a name="input_webhooksEnabled"></a> [webhooksEnabled](#input\_webhooksEnabled) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->