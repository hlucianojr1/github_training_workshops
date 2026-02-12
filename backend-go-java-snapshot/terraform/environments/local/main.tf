# Local Environment - Rancher Desktop Kubernetes
terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

# Kubernetes provider for Rancher Desktop (uses local kubeconfig)
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

# Note: Azure provider removed from local environment
# The database module has been updated to separate Azure-specific resources
# into a conditional module to avoid requiring Azure authentication for local deployments

# Create namespace
resource "kubernetes_namespace" "highscores" {
  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = "local"
      managed-by  = "terraform"
    }
  }
}

# Database module - PostgreSQL StatefulSet
module "database" {
  source = "../../modules/database"

  app_name           = "highscores-postgres"
  namespace          = kubernetes_namespace.highscores.metadata[0].name
  environment        = "local"
  
  # Use StatefulSet for local deployment
  use_statefulset    = true
  use_rds            = false
  use_azure_postgres = false

  database_name      = var.database_name
  database_username  = var.database_username
  database_password  = var.database_password

  postgres_image     = var.postgres_image
  storage_class      = var.storage_class
  storage_size       = var.storage_size

  resources = {
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

# Backend module - Spring Boot
module "backend" {
  source = "../../modules/backend"

  app_name          = "highscores-backend"
  namespace         = kubernetes_namespace.highscores.metadata[0].name
  image             = var.backend_image
  image_pull_policy = var.image_pull_policy
  replicas          = var.backend_replicas

  spring_profile    = "prod"
  database_url      = module.database.jdbc_url
  database_username = var.database_username
  database_password = var.database_password

  resources = {
    requests = {
      cpu    = "250m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
  }

  enable_autoscaling = false

  depends_on = [module.database]
}

# Frontend module - React + Nginx
module "frontend" {
  source = "../../modules/frontend"

  app_name          = "highscores-frontend"
  namespace         = kubernetes_namespace.highscores.metadata[0].name
  image             = var.frontend_image
  image_pull_policy = var.image_pull_policy
  replicas          = var.frontend_replicas

  backend_url = "http://${module.backend.service_name}:${module.backend.service_port}"

  resources = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "256Mi"
    }
  }

  enable_autoscaling = false

  depends_on = [module.backend]
}

# Ingress module - Route traffic
module "ingress" {
  source = "../../modules/ingress"

  app_name        = "highscores"
  namespace       = kubernetes_namespace.highscores.metadata[0].name
  domain_name     = var.domain_name
  ingress_class   = var.ingress_class

  backend_service_name  = module.backend.service_name
  backend_service_port  = module.backend.service_port
  frontend_service_name = module.frontend.service_name
  frontend_service_port = module.frontend.service_port

  enable_tls = false

  ingress_annotations = {
    "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
  }

  depends_on = [module.backend, module.frontend]
}
