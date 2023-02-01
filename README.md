<!-- BEGIN_TF_DOCS -->

# Azure Kubernetes Cluster and Diagnostic Setting module

## Examples
```hcl
module "aks" {
  source = "./modules/compute/aks"

  aks_name                   = "brumer-final-terraform-workspoke-aks"
  resource_group_name        = "brumer-final-terraform-workspoke"
  location                   = "West Europe"
  service_cidr               = "192.168.0.0/16"
  node_resource_group        = "MC-brumer-final-terraform-workspoke"
  log_analytics_workspace_id = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourcegroups/brumer-final-terraform-hub-rg/providers/microsoft.operationalinsights/workspaces/brumer-final-terraform-hub-log-analytics"
  private_dns_zone_id        = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-workspoke-rg/providers/Microsoft.Network/privateDnsZones/brumerfinalterraform.private.westeurope.azmk8s.io"
  docker_bridge_cidr         = "192.167.0.1/16"
  aks_network_policy         = "None"
  default_node_pool = {
    name           = "default"
    count          = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-workspoke-rg/providers/Microsoft.Network/virtualNetworks/brumer-final-terraform-workspoke-vnet/subnets/AksSubnet"
  }

  aks_network_plugin = "azure"
  identity_type      = "UserAssigned"
  identity_ids = [
    "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-workspoke-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-identity"
  ]
}
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of aks. |
| <a name="output_name"></a> [name](#output\_name) | Name of aks. |
| <a name="output_object"></a> [object](#output\_object) | Object of aks. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Id of aks principall. |
| <a name="output_private_dns_zone_a_record_name"></a> [private\_dns\_zone\_a\_record\_name](#output\_private\_dns\_zone\_a\_record\_name) | Name of A record of the private dns zone. |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | Name of private dns zone. |
| <a name="output_private_fqdn"></a> [private\_fqdn](#output\_private\_fqdn) | Private FQDN of aks. |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | (Required)AKS name. | `string` | n/a | yes |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | (Required)Default node pool configuration. | <pre>object({<br>    name                  = string<br>    count                 = number<br>    vm_size               = string<br>    vnet_subnet_id        = optional(string)<br>    os_type               = optional(string, "Linux")<br>    zones                 = optional(list(number))<br>    enable_auto_scaling   = optional(bool)<br>    min_count             = optional(number)<br>    max_count             = optional(number)<br>    type                  = optional(string)<br>    node_taints           = optional(list(string))<br>    max_pods              = optional(number)<br>    os_disk_type          = optional(string, "Managed")<br>    os_disk_size_gb       = optional(number)<br>    enable_node_public_ip = optional(bool)<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)A container that holds related resources for an Azure solution. | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | (Optional)CIDR used by kubernetes services (kubectl get svc). | `string` | n/a | yes |
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | (Optional)ACR id, uses to create role assigment so the aks could pull images from specific acr. | `string` | `null` | no |
| <a name="input_aks_network_plugin"></a> [aks\_network\_plugin](#input\_aks\_network\_plugin) | (Optional)AKS network plugin to use. Possible values are `azure` and `kubenet`. Changing this forces a new resource to be created. | `string` | `"kubenet"` | no |
| <a name="input_aks_network_policy"></a> [aks\_network\_policy](#input\_aks\_network\_policy) | (Optional)Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created. | `string` | `"calico"` | no |
| <a name="input_aks_pod_cidr"></a> [aks\_pod\_cidr](#input\_aks\_pod\_cidr) | (Optional)CIDR used by pods when network plugin is set to `kubenet`. git::https://docs.microsoft.com/en-us/azure/aks/configure-kubenet. | `string` | `"10.244.0.0/16"` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | (Optional)aks sku tier. Possible values are Free ou Paid. | `string` | `"Free"` | no |
| <a name="input_docker_bridge_cidr"></a> [docker\_bridge\_cidr](#input\_docker\_bridge\_cidr) | (Optional)IP address for docker with Network CIDR. | `string` | `"172.17.0.1/16"` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional)Specifies a list of User Assigned Managed Identity IDs to be assigned to this Virtual Machine. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional)The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` or `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well. | `string` | `"SystemAssigned"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional)Version of Kubernetes to deploy. | `string` | `"1.23.12"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Required)Log analytics workspace id to send logs from the current resource. | `string` | `null` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | (Optional)Network mode to be used with Azure CNI. Possible values are bridge and transparent. Changing this forces a new resource to be created. | `string` | `"transparent"` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | (Optional)Name of the resource group in which to put AKS nodes. If null default to MC\_<AKS RG Name>. | `string` | `null` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | (Optional)The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer` and `userDefinedRouting`. | `string` | `"loadBalancer"` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional)Id of the private DNS Zone. | `string` | `null` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | (Optional)Specifies the list of Private DNS Zones to include within the private\_dns\_zone\_group. | `list(string)` | `[]` | no |



# Authors
Originally created by Omer Brumer
<!-- END_TF_DOCS -->