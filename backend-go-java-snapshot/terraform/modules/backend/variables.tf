variable "app_name" {
  description = "Name of the backend application"
  type        = string
  default     = "highscores-backend"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "image" {
  description = "Docker image for the backend"
  type        = string
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "spring_profile" {
  description = "Spring Boot profile (default or prod)"
  type        = string
  default     = "prod"
}

variable "database_url" {
  description = "JDBC database URL"
  type        = string
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

variable "extra_env_vars" {
  description = "Additional environment variables as key-value pairs"
  type        = map(string)
  default     = {}
}

variable "resources" {
  description = "Resource requests and limits"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "250m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
  }
}

variable "enable_autoscaling" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = false
}

variable "autoscaling_min_replicas" {
  description = "Minimum number of replicas for autoscaling"
  type        = number
  default     = 2
}

variable "autoscaling_max_replicas" {
  description = "Maximum number of replicas for autoscaling"
  type        = number
  default     = 10
}

variable "autoscaling_target_cpu" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = 70
}

variable "autoscaling_target_memory" {
  description = "Target memory utilization percentage for autoscaling"
  type        = number
  default     = 80
}
