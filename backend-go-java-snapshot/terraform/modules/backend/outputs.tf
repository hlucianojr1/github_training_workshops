output "service_name" {
  description = "Name of the backend service"
  value       = kubernetes_service.backend.metadata[0].name
}

output "service_port" {
  description = "Port of the backend service"
  value       = kubernetes_service.backend.spec[0].port[0].port
}

output "deployment_name" {
  description = "Name of the backend deployment"
  value       = kubernetes_deployment.backend.metadata[0].name
}

output "namespace" {
  description = "Namespace of the backend resources"
  value       = kubernetes_deployment.backend.metadata[0].namespace
}
