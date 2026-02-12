variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "highscores"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "ingress_class" {
  description = "Ingress class name (e.g., nginx, traefik)"
  type        = string
  default     = "nginx"
}

variable "backend_service_name" {
  description = "Name of the backend service"
  type        = string
}

variable "backend_service_port" {
  description = "Port of the backend service"
  type        = number
  default     = 8080
}

variable "frontend_service_name" {
  description = "Name of the frontend service"
  type        = string
}

variable "frontend_service_port" {
  description = "Port of the frontend service"
  type        = number
  default     = 80
}

variable "enable_tls" {
  description = "Enable TLS/SSL"
  type        = bool
  default     = false
}

variable "cert_issuer" {
  description = "Certificate issuer for cert-manager"
  type        = string
  default     = "letsencrypt-prod"
}

variable "ingress_annotations" {
  description = "Additional annotations for the ingress"
  type        = map(string)
  default     = {}
}

variable "enable_network_policy" {
  description = "Enable network policy for additional security"
  type        = bool
  default     = false
}

variable "ingress_namespace" {
  description = "Namespace of the ingress controller"
  type        = string
  default     = "ingress-nginx"
}
