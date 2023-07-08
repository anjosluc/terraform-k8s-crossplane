resource "helm_release" "crossplane_install" {
  chart            = "crossplane"
  name             = "crossplane"
  namespace        = var.crossplaneNamespace

  force_update     = false
  create_namespace = true
  repository       = "https://charts.crossplane.io/stable"
  version          = "1.10.1"

  set {
    name  = "image.repository"
    value = var.imageRepository
  }

  set {
    name  = "replicas"
    value = var.replicas
  }

  set {
    name  = "provider.packages"
    value = "{${replace(join(",", var.providerPackages), "\"", "")}}"
  }

  set {
    name  = "configuration.packages"
    value = "{${replace(join(",", var.configurationPackages), "\"", "")}}"
  }

  set {
    name  = "webhooks.enabled"
    value = var.webhooksEnabled
  }

}

resource "kubectl_manifest" "controller_config_aws" {
  count     = var.createRoleforAWSProvider ? 1 : 0
  
  depends_on = [
    helm_release.crossplane_install
  ]

  yaml_body = <<YAML
apiVersion: pkg.crossplane.io/v1alpha1
kind: ControllerConfig
metadata:
  name: aws-config
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/role-crossplane-provider-aws
spec:
  args:
  - --debug
  podSecurityContext:
    fsGroup: 2000
YAML

}

resource "kubectl_manifest" "provider" {
  count     = var.createRoleforAWSProvider ? 1 : 0
  
  depends_on = [
    helm_release.crossplane_install
  ]

  yaml_body = <<YAML
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-contrib
spec:
  package: harbor.example.com/docker-hub/crossplane/provider-aws:master
  controllerConfigRef:
    name: aws-config
YAML

}