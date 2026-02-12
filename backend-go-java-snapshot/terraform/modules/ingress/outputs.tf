output "ingress_name" {
  description = "Name of the ingress resource"
  value       = kubernetes_ingress_v1.main.metadata[0].name
}

output "ingress_hostname" {
  description = "Hostname configured for the ingress"
  value       = var.domain_name
}

output "ingress_class" {
  description = "Ingress class used"
  value       = var.ingress_class
}

output "tls_enabled" {
  description = "Whether TLS is enabled"
  value       = var.enable_tls
}
