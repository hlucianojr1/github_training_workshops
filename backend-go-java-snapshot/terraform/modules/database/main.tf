# Database Module - PostgreSQL StatefulSet for Kubernetes
# For local: StatefulSet with PVC
# For Azure: Use Azure-managed PostgreSQL (resources defined in azure environment, not here)

# StatefulSet for local Kubernetes (Rancher Desktop)
resource "kubernetes_stateful_set" "postgres" {
  count = var.use_statefulset ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "database"
      tier      = "data"
    }
  }

  spec {
    service_name = kubernetes_service.postgres_headless[0].metadata[0].name
    replicas     = 1

    selector {
      match_labels = {
        app       = var.app_name
        component = "database"
      }
    }

    template {
      metadata {
        labels = {
          app       = var.app_name
          component = "database"
          tier      = "data"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image

          port {
            container_port = 5432
            name          = "postgres"
          }

          env {
            name  = "POSTGRES_DB"
            value = var.database_name
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres[0].metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres[0].metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }

          resources {
            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_username]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_username]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgres-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = var.storage_class
        resources {
          requests = {
            storage = var.storage_size
          }
        }
      }
    }
  }
}

# Headless service for StatefulSet
resource "kubernetes_service" "postgres_headless" {
  count = var.use_statefulset ? 1 : 0

  metadata {
    name      = "${var.app_name}-headless"
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "database"
    }
  }

  spec {
    selector = {
      app       = var.app_name
      component = "database"
    }

    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }

    cluster_ip = "None"
  }
}

# Regular service for database access
resource "kubernetes_service" "postgres" {
  count = var.use_statefulset ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "database"
    }
  }

  spec {
    selector = {
      app       = var.app_name
      component = "database"
    }

    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Secret for database credentials
resource "kubernetes_secret" "postgres" {
  count = var.use_statefulset ? 1 : 0

  metadata {
    name      = "${var.app_name}-secret"
    namespace = var.namespace
  }

  data = {
    username = base64encode(var.database_username)
    password = base64encode(var.database_password)
  }

  type = "Opaque"
}
