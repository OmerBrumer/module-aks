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