output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.highscores.metadata[0].name
}

output "database_host" {
  description = "Database host"
  value       = module.database.database_host
}

output "backend_service" {
  description = "Backend service name"
  value       = module.backend.service_name
}

output "frontend_service" {
  description = "Frontend service name"
  value       = module.frontend.service_name
}

output "ingress_hostname" {
  description = "Application hostname"
  value       = module.ingress.ingress_hostname
}

output "access_instructions" {
  description = "Instructions to access the application"
  value = <<-EOT
    To access the application locally:
    
    1. Add to /etc/hosts:
       127.0.0.1 ${module.ingress.ingress_hostname}
    
    2. Access the application:
       http://${module.ingress.ingress_hostname}
    
    3. Port forward if needed:
       kubectl port-forward -n ${kubernetes_namespace.highscores.metadata[0].name} svc/${module.frontend.service_name} 3000:80
       kubectl port-forward -n ${kubernetes_namespace.highscores.metadata[0].name} svc/${module.backend.service_name} 8080:8080
  EOT
}
