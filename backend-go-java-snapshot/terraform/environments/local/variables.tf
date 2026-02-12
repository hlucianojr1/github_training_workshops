variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "rancher-desktop"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "highscores-local"
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "highscores"
}

variable "database_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "postgres_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:16-alpine"
}

variable "storage_class" {
  description = "Storage class for PVC (Rancher Desktop uses local-path)"
  type        = string
  default     = "local-path"
}

variable "storage_size" {
  description = "Storage size for database PVC"
  type        = string
  default     = "5Gi"
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
  default     = "highscores-backend:latest"
}

variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
  default     = "highscores-frontend:latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 1
}

variable "frontend_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 1
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "highscores.local"
}

variable "ingress_class" {
  description = "Ingress class (Rancher Desktop uses traefik by default)"
  type        = string
  default     = "traefik"
}
