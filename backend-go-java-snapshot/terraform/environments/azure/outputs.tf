output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.highscores.metadata[0].name
}

output "postgres_fqdn" {
  description = "Azure PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
  sensitive   = true
}

output "postgres_id" {
  description = "Azure PostgreSQL server ID"
  value       = azurerm_postgresql_flexible_server.postgres.id
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

output "load_balancer_ip" {
  description = "Load balancer IP address (check after deployment)"
  value       = "Run: kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}

output "access_instructions" {
  description = "Instructions to access the application"
  value = <<-EOT
    Azure Deployment Complete!
    
    1. Get Load Balancer IP:
       kubectl get ingress -n ${kubernetes_namespace.highscores.metadata[0].name} ${module.ingress.ingress_name} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    
    2. Update DNS:
       Create an A record for ${module.ingress.ingress_hostname} pointing to the Load Balancer IP
    
    3. Access application:
       https://${module.ingress.ingress_hostname}
    
    4. Monitor pods:
       kubectl get pods -n ${kubernetes_namespace.highscores.metadata[0].name}
       kubectl logs -n ${kubernetes_namespace.highscores.metadata[0].name} -l app=highscores-backend -f
    
    5. Database connection (from within cluster):
       Host: ${azurerm_postgresql_flexible_server.postgres.fqdn}
       Database: ${var.database_name}
       Port: 5432
  EOT
}
