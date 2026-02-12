output "service_name" {
  description = "Name of the frontend service"
  value       = kubernetes_service.frontend.metadata[0].name
}

output "service_port" {
  description = "Port of the frontend service"
  value       = kubernetes_service.frontend.spec[0].port[0].port
}

output "deployment_name" {
  description = "Name of the frontend deployment"
  value       = kubernetes_deployment.frontend.metadata[0].name
}

output "namespace" {
  description = "Namespace of the frontend resources"
  value       = kubernetes_deployment.frontend.metadata[0].namespace
}
