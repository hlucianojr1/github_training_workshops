output "database_host" {
  description = "Database host address (Kubernetes service)"
  value       = var.use_statefulset && length(kubernetes_service.postgres) > 0 ? "${kubernetes_service.postgres[0].metadata[0].name}.${var.namespace}.svc.cluster.local" : ""
}

output "database_port" {
  description = "Database port"
  value       = 5432
}

output "database_name" {
  description = "Database name"
  value       = var.database_name
}

output "jdbc_url" {
  description = "JDBC connection URL (for Kubernetes StatefulSet)"
  value       = var.use_statefulset && length(kubernetes_service.postgres) > 0 ? "jdbc:postgresql://${kubernetes_service.postgres[0].metadata[0].name}.${var.namespace}.svc.cluster.local:5432/${var.database_name}" : ""
}

output "service_name" {
  description = "Kubernetes service name (if using StatefulSet)"
  value       = var.use_statefulset && length(kubernetes_service.postgres) > 0 ? kubernetes_service.postgres[0].metadata[0].name : null
}
