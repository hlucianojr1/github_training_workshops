# Frontend Module - React + Nginx Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "frontend"
      tier      = "presentation"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app       = var.app_name
        component = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app       = var.app_name
          component = "frontend"
          tier      = "presentation"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = var.image
          image_pull_policy = var.image_pull_policy

          port {
            container_port = 80
            name          = "http"
            protocol      = "TCP"
          }

          env {
            name  = "BACKEND_URL"
            value = var.backend_url
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

          # Liveness probe
          liveness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Readiness probe
          readiness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Startup probe
          startup_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 10
          }
        }

        # Security context
        security_context {
          run_as_non_root = true
          run_as_user     = 101  # nginx user in nginx:alpine
          fs_group        = 101
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

# Frontend Service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app       = var.app_name
      component = "frontend"
    }
  }

  spec {
    selector = {
      app       = var.app_name
      component = "frontend"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "frontend" {
  count = var.enable_autoscaling ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.frontend.metadata[0].name
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
