# Azure Region and Subscription
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

variable "azure_location" {
  description = "Azure location/region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# AKS Configuration
variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "highscores-prod"
}

# Database Configuration
variable "database_name" {
  description = "Database name"
  type        = string
  default     = "highscores"
}

variable "database_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Azure PostgreSQL Configuration
variable "postgres_server_name" {
  description = "Azure PostgreSQL server name (must be globally unique)"
  type        = string
}

variable "postgres_sku_name" {
  description = "Azure PostgreSQL SKU (B_Standard_B1ms, GP_Standard_D2s_v3, etc.)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage in MB"
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Azure availability zone"
  type        = string
  default     = "1"
}

variable "allowed_ip_ranges" {
  description = "IP ranges allowed to access PostgreSQL"
  type = list(object({
    start_ip = string
    end_ip   = string
  }))
  default = []
}

# Container Images
variable "backend_image" {
  description = "Backend Docker image (from ACR)"
  type        = string
}

variable "frontend_image" {
  description = "Frontend Docker image (from ACR)"
  type        = string
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "Always"
}

# Backend Configuration
variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 2
}

variable "backend_cpu_request" {
  description = "Backend CPU request"
  type        = string
  default     = "250m"
}

variable "backend_memory_request" {
  description = "Backend memory request"
  type        = string
  default     = "512Mi"
}

variable "backend_cpu_limit" {
  description = "Backend CPU limit"
  type        = string
  default     = "1000m"
}

variable "backend_memory_limit" {
  description = "Backend memory limit"
  type        = string
  default     = "1Gi"
}

variable "backend_autoscaling_min" {
  description = "Backend minimum replicas for autoscaling"
  type        = number
  default     = 2
}

variable "backend_autoscaling_max" {
  description = "Backend maximum replicas for autoscaling"
  type        = number
  default     = 10
}

# Frontend Configuration
variable "frontend_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 2
}

variable "frontend_cpu_request" {
  description = "Frontend CPU request"
  type        = string
  default     = "100m"
}

variable "frontend_memory_request" {
  description = "Frontend memory request"
  type        = string
  default     = "128Mi"
}

variable "frontend_cpu_limit" {
  description = "Frontend CPU limit"
  type        = string
  default     = "500m"
}

variable "frontend_memory_limit" {
  description = "Frontend memory limit"
  type        = string
  default     = "256Mi"
}

variable "frontend_autoscaling_min" {
  description = "Frontend minimum replicas for autoscaling"
  type        = number
  default     = 2
}

variable "frontend_autoscaling_max" {
  description = "Frontend maximum replicas for autoscaling"
  type        = number
  default     = 10
}

# Autoscaling
variable "enable_autoscaling" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

# Ingress Configuration
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "ingress_class" {
  description = "Ingress class (nginx or azure/application-gateway)"
  type        = string
  default     = "nginx"
}

variable "enable_tls" {
  description = "Enable TLS/HTTPS"
  type        = bool
  default     = true
}

variable "cert_issuer" {
  description = "Certificate issuer for cert-manager"
  type        = string
  default     = "letsencrypt-prod"
}

variable "appgw_ssl_certificate_name" {
  description = "Application Gateway SSL certificate name (if using App Gateway)"
  type        = string
  default     = ""
}

variable "use_private_ip" {
  description = "Use private IP for Application Gateway"
  type        = bool
  default     = false
}
