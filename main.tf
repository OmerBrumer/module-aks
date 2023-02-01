/**
* # Azure Kubernetes Cluster and Diagnostic Setting module
*/

resource "azurerm_kubernetes_cluster" "aks" {
  name                          = var.aks_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  dns_prefix_private_cluster    = replace(var.aks_name, "/[\\W_]/", "-")
  kubernetes_version            = var.kubernetes_version
  sku_tier                      = var.aks_sku_tier
  node_resource_group           = var.node_resource_group
  private_cluster_enabled       = true
  public_network_access_enabled = false
  private_dns_zone_id           = var.private_dns_zone_id

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    zones               = var.default_node_pool.zones
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.min_count
    max_count           = var.default_node_pool.max_count
    max_pods            = var.default_node_pool.max_pods
    os_disk_type        = var.default_node_pool.os_disk_type
    os_disk_size_gb     = var.default_node_pool.os_disk_size_gb
    type                = var.default_node_pool.type
    node_taints         = var.default_node_pool.node_taints
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id == null ? null : var.log_analytics_workspace_id
  }

  network_profile {
    network_plugin     = var.aks_network_plugin
    network_policy     = var.aks_network_plugin == "azure" ? "azure" : var.aks_network_policy
    network_mode       = var.aks_network_plugin == "azure" ? var.network_mode : null
    dns_service_ip     = cidrhost(var.service_cidr, 10)
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = "standard"
    outbound_type      = var.outbound_type
    pod_cidr           = var.aks_network_plugin == "kubenet" ? var.aks_pod_cidr : null
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "diagnostic_settings" {
  source = "git::https://gitlab.com/OmerBrumer/diagnostic_setting.git"

  diagonstic_setting_name    = "${azurerm_kubernetes_cluster.aks.name}-diagnostic-setting"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = azurerm_kubernetes_cluster.aks.id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}