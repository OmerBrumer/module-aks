output "id" {
  description = "Id of aks."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "name" {
  description = "Name of aks."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "object" {
  description = "Object of aks."
  value       = azurerm_kubernetes_cluster.aks
}

output "private_dns_zone_name" {
  description = "Name of private dns zone."
  value       = join(".", slice(split(".", azurerm_kubernetes_cluster.aks.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.aks.private_fqdn))))
}

output "private_dns_zone_a_record_name" {
  description = "Name of A record of the private dns zone."
  value       = split(".", azurerm_kubernetes_cluster.aks.private_fqdn)[0]
}

output "principal_id" {
  description = "Id of aks principall."
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "private_fqdn" {
  description = "Private FQDN of aks."
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}  