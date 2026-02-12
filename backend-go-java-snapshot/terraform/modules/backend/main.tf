# Backend Module - Spring Boot Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "backend"
      tier      = "application"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app       = var.app_name
        component = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app       = var.app_name
          component = "backend"
          tier      = "application"
        }
      }

      spec {
        container {
          name  = "backend"
          image = var.image
          image_pull_policy = var.image_pull_policy

          port {
            container_port = 8080
            name          = "http"
            protocol      = "TCP"
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = var.spring_profile
          }

          env {
            name  = "DATABASE_URL"
            value = var.database_url
          }

          env {
            name = "DATABASE_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secrets.metadata[0].name
                key  = "database-username"
              }
            }
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secrets.metadata[0].name
                key  = "database-password"
              }
            }
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          # Additional environment variables
          dynamic "env" {
            for_each = var.extra_env_vars
            content {
              name  = env.key
              value = env.value
            }
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

          # Liveness probe - checks if container is alive
          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = 8080
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Readiness probe - checks if container is ready to accept traffic
          readiness_probe {
            http_get {
              path = "/actuator/health/readiness"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Startup probe - for slow-starting containers
          startup_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 30
          }
        }

        # Security context
        security_context {
          run_as_non_root = true
          run_as_user     = 1000
          fs_group        = 1000
        }
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }
  }
}

# Backend Service
resource "kubernetes_service" "backend" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "backend"
    }
  }

  spec {
    selector = {
      app       = var.app_name
      component = "backend"
    }

    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Backend Secrets
resource "kubernetes_secret" "backend_secrets" {
  metadata {
    name      = "${var.app_name}-secrets"
    namespace = var.namespace
  }

  data = {
    database-username = base64encode(var.database_username)
    database-password = base64encode(var.database_password)
  }

  type = "Opaque"
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "backend" {
  count = var.enable_autoscaling ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.backend.metadata[0].name
    }

    min_replicas = var.autoscaling_min_replicas
    max_replicas = var.autoscaling_max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.autoscaling_target_cpu
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = var.autoscaling_target_memory
        }
      }
    }
  }
}
