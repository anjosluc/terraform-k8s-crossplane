variable "createRoleforAWSProvider" {
    type = bool
    default = true
}

variable "clusterName" {
    type = string
}

variable "crossplaneNamespace" {
    type = string
    default = "crossplane-system"
}

variable "imageRepository" {
    type = string
    default = "harbor.example.com/docker-hub/crossplane/crossplane"
}

variable "replicas" {
    type = number
    default = 3
}

variable "providerPackages" {
    type = list(string)
    default = [ 
        #"xpkg.upbound.io/crossplane-contrib/provider-aws:v0.33.0",
        # "xpkg.upbound.io/crossplane-contrib/provider-gcp:v0.22.0",
        # "xpkg.upbound.io/upbound/provider-azure:v0.17.0",
        # "xpkg.upbound.io/crossplane-contrib/provider-argocd:v0.2.0",
        #"xpkg.upbound.io/crossplane-contrib/provider-helm:v0.12.0",
        #"xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.5.0",
        #"xpkg.upbound.io/crossplane-contrib/provider-terraform:v0.4.0"
    ]
}

variable "configurationPackages" {
    type = list(string)
    default = [ 
        #"xpkg.upbound.io/devops-toolkit/dot-kubernetes:v0.5.9"
    ]
}

variable "webhooksEnabled" {
    type = bool
    default = true
}