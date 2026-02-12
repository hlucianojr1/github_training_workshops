variable "app_name" {
  description = "Name of the database application"
  type        = string
  default     = "highscores-postgres"
}

variable "namespace" {
  description = "Kubernetes namespace (for StatefulSet)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Common database settings
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

# Deployment type
variable "use_statefulset" {
  description = "Use Kubernetes StatefulSet for database (local deployment)"
  type        = bool
  default     = true
}

variable "use_rds" {
  description = "Use AWS RDS for database (cloud deployment) - DEPRECATED"
  type        = bool
  default     = false
}

variable "use_azure_postgres" {
  description = "Use Azure Database for PostgreSQL (cloud deployment)"
  type        = bool
  default     = false
}

# StatefulSet settings
variable "postgres_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:16-alpine"
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "storage_class" {
  description = "Storage class for PVC"
  type        = string
  default     = "local-path"
}

variable "storage_size" {
  description = "Storage size for PVC"
  type        = string
  default     = "10Gi"
}

variable "resources" {
  description = "Resource requests and limits for StatefulSet"
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

# AWS RDS settings
variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "highscores-postgres"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "rds_vpc_security_group_ids" {
  description = "VPC security group IDs for RDS"
  type        = list(string)
  default     = []
}

variable "rds_subnet_group_name" {
  description = "DB subnet group name for RDS"
  type        = string
  default     = ""
}

variable "rds_subnet_ids" {
  description = "Subnet IDs for RDS subnet group"
  type        = list(string)
  default     = []
}

variable "create_rds_subnet_group" {
  description = "Create RDS subnet group"
  type        = bool
  default     = false
}

variable "rds_publicly_accessible" {
  description = "Whether RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS"
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "tags" {
  description = "Tags to apply to cloud resources"
  type        = map(string)
  default     = {}
}

# Azure-specific variables
variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = ""
}

variable "azure_location" {
  description = "Azure location/region"
  type        = string
  default     = "eastus"
}

variable "postgres_server_name" {
  description = "Azure PostgreSQL server name (must be globally unique)"
  type        = string
  default     = "highscores-postgres"
}

variable "postgres_sku_name" {
  description = "Azure PostgreSQL SKU name (e.g., B_Standard_B1ms, GP_Standard_D2s_v3)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Azure PostgreSQL storage in MB"
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
  description = "List of IP ranges allowed to access the database"
  type = list(object({
    start_ip = string
    end_ip   = string
  }))
  default = []
}

variable "postgres_configurations" {
  description = "PostgreSQL server configurations"
  type        = map(string)
  default     = {}
}
