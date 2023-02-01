variable "resource_group_name" {
  description = "(Required)A container that holds related resources for an Azure solution."
  type        = string
}

variable "location" {
  description = "(Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'."
  type        = string
}

variable "aks_name" {
  description = "(Required)AKS name."
  type        = string
}

variable "default_node_pool" {
  description = <<EOF
    (Required)Default node pool configuration.
    name - (Required)The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created.
    size - (Required) The size of the Virtual Machine.
    enable_auto_scaling - (Optional)Should the Kubernetes Auto Scaler be enabled for this Node Pool?
    min_count - (Optional)The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000
    max_count - (Optional)The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.
    zones - (Optional)Specifies a list of Availability Zones in which this Kubernetes Cluster should be located. Changing this forces a new Kubernetes Cluster to be created.
    count - (Optional)The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count.
    os_disk_size_gb - (Optional)The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created.
    os_disk_type - (Optional)The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created.
    node_taints - (Optional)A list of the taints added to new nodes during node pool create and scale. Changing this forces a new resource to be created.
    max_pods - (Optional)The maximum number of pods that can run on each agent. Changing this forces a new resource to be created.
  EOF
  type = object({
    name                = string
    count               = number
    vm_size             = string
    vnet_subnet_id      = optional(string)
    os_type             = optional(string, "Linux")
    zones               = optional(list(number))
    enable_auto_scaling = optional(bool)
    min_count           = optional(number, 1)
    max_count           = optional(number, 1000)
    type                = optional(string, "VirtualMachineScaleSets")
    node_taints         = optional(list(string))
    max_pods            = optional(number, 80)
    os_disk_type        = optional(string, "Managed")
    os_disk_size_gb     = optional(number, 60)
  })
}

variable "kubernetes_version" {
  description = "(Optional)Version of Kubernetes to deploy."
  type        = string
  default     = "1.23.12"
}

variable "identity_type" {
  description = "(Optional)The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` or `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned` or `UserAssigned`."
  }
}

variable "identity_ids" {
  description = "(Optional)Specifies a list of User Assigned Managed Identity IDs to be assigned to this Virtual Machine."
  type        = list(string)
  default     = null
}

variable "node_resource_group" {
  description = "(Optional)Name of the resource group in which to put AKS nodes. If null default to MC_<AKS RG Name>."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "(Optional)Id of the private DNS Zone."
  type        = string
  default     = null
}

variable "aks_sku_tier" {
  description = "(Optional)aks sku tier. Possible values are Free ou Paid."
  type        = string
  default     = "Free"
}

variable "aks_network_plugin" {
  description = "(Optional)AKS network plugin to use. Possible values are `azure` and `kubenet`. Changing this forces a new resource to be created."
  type        = string
  default     = "kubenet"

  validation {
    condition     = contains(["azure", "kubenet"], var.aks_network_plugin)
    error_message = "The network plugin value must be \"azure\" or \"kubenet\"."
  }
}

variable "network_mode" {
  description = "(Optional)Network mode to be used with Azure CNI. Possible values are bridge and transparent. Changing this forces a new resource to be created."
  type        = string
  default     = "transparent"

  validation {
    condition     = contains(["transparent", "bridge"], var.network_mode)
    error_message = "The network plugin value must be \"transparent\" or \"bridge\"."
  }
}

variable "aks_network_policy" {
  description = "(Optional)Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = "calico"
}

variable "service_cidr" {
  description = "(Required)CIDR used by kubernetes services (kubectl get svc)."
  type        = string
}

variable "aks_pod_cidr" {
  description = "(Optional)CIDR used by pods when network plugin is set to `kubenet`. git::https://docs.microsoft.com/en-us/azure/aks/configure-kubenet."
  type        = string
  default     = "10.244.0.0/16"
}

variable "outbound_type" {
  description = "(Optional)The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer` and `userDefinedRouting`."
  type        = string
  default     = "loadBalancer"
}

variable "docker_bridge_cidr" {
  description = "(Optional)IP address for docker with Network CIDR."
  type        = string
  default     = "172.17.0.1/16"
}

variable "private_dns_zone_ids" {
  description = "(Optional)Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
  type        = list(string)
  default     = []
}

variable "acr_id" {
  description = "(Optional)ACR id, uses to create role assigment so the aks could pull images from specific acr."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "(Required)Log analytics workspace id to send logs from the current resource."
  type        = string
}