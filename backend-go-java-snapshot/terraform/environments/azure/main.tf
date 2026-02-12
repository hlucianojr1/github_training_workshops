# Azure Environment - AKS + Azure Database for PostgreSQL
terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Remote backend for state management
  backend "azurerm" {
    # Configure via backend-config or environment variables
    # resource_group_name  = "terraform-state-rg"
    # storage_account_name = "tfstate"
    # container_name       = "tfstate"
    # key                  = "highscores.terraform.tfstate"
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# Data source for AKS cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

# Kubernetes provider for AKS
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

# Create namespace
resource "kubernetes_namespace" "highscores" {
  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

# Azure Database for PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = var.postgres_server_name
  resource_group_name = var.resource_group_name
  location            = var.azure_location

  administrator_login    = var.database_username
  administrator_password = var.database_password

  sku_name   = var.postgres_sku_name
  version    = "16"
  storage_mb = var.postgres_storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup

  zone = var.availability_zone

  tags = {
    Project     = "highscores"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Azure PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "highscores" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Firewall rules to allow AKS access
resource "azurerm_postgresql_flexible_server_firewall_rule" "aks" {
  count = length(var.allowed_ip_ranges)

  name             = "allow-aks-${count.index}"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = var.allowed_ip_ranges[count.index].start_ip
  end_ip_address   = var.allowed_ip_ranges[count.index].end_ip
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
  database_url      = "jdbc:postgresql://${azurerm_postgresql_flexible_server.postgres.fqdn}:5432/${var.database_name}?sslmode=require"
  database_username = var.database_username
  database_password = var.database_password

  resources = {
    requests = {
      cpu    = var.backend_cpu_request
      memory = var.backend_memory_request
    }
    limits = {
      cpu    = var.backend_cpu_limit
      memory = var.backend_memory_limit
    }
  }

  enable_autoscaling        = var.enable_autoscaling
  autoscaling_min_replicas  = var.backend_autoscaling_min
  autoscaling_max_replicas  = var.backend_autoscaling_max
  autoscaling_target_cpu    = 70
  autoscaling_target_memory = 80

  depends_on = [azurerm_postgresql_flexible_server_database.highscores]
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
      cpu    = var.frontend_cpu_request
      memory = var.frontend_memory_request
    }
    limits = {
      cpu    = var.frontend_cpu_limit
      memory = var.frontend_memory_limit
    }
  }

  enable_autoscaling        = var.enable_autoscaling
  autoscaling_min_replicas  = var.frontend_autoscaling_min
  autoscaling_max_replicas  = var.frontend_autoscaling_max
  autoscaling_target_cpu    = 70
  autoscaling_target_memory = 80

  depends_on = [module.backend]
}

# Ingress module - Route traffic with Azure Application Gateway or nginx
module "ingress" {
  source = "../../modules/ingress"

  app_name      = "highscores"
  namespace     = kubernetes_namespace.highscores.metadata[0].name
  domain_name   = var.domain_name
  ingress_class = var.ingress_class

  backend_service_name  = module.backend.service_name
  backend_service_port  = module.backend.service_port
  frontend_service_name = module.frontend.service_name
  frontend_service_port = module.frontend.service_port

  enable_tls  = var.enable_tls
  cert_issuer = var.cert_issuer

  ingress_annotations = merge(
    var.ingress_class == "azure/application-gateway" ? {
      "appgw.ingress.kubernetes.io/backend-path-prefix" = "/"
      "appgw.ingress.kubernetes.io/ssl-redirect"        = var.enable_tls ? "true" : "false"
      "appgw.ingress.kubernetes.io/use-private-ip"      = var.use_private_ip ? "true" : "false"
    } : {},
    var.enable_tls && var.ingress_class == "azure/application-gateway" ? {
      "appgw.ingress.kubernetes.io/appgw-ssl-certificate" = var.appgw_ssl_certificate_name
    } : {}
  )

  depends_on = [module.backend, module.frontend]
}
