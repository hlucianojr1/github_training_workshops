# Ingress Module - Route traffic to backend and frontend
resource "kubernetes_ingress_v1" "main" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
    annotations = merge(
      var.ingress_annotations,
      var.enable_tls ? {
        "cert-manager.io/cluster-issuer" = var.cert_issuer
      } : {}
    )
  }

  spec {
    ingress_class_name = var.ingress_class

    # TLS configuration
    dynamic "tls" {
      for_each = var.enable_tls ? [1] : []
      content {
        hosts       = [var.domain_name]
        secret_name = "${var.app_name}-tls"
      }
    }

    # Backend API routing
    rule {
      host = var.domain_name

      http {
        # API routes
        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = var.backend_service_name
              port {
                number = var.backend_service_port
              }
            }
          }
        }

        # Frontend routes
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.frontend_service_name
              port {
                number = var.frontend_service_port
              }
            }
          }
        }
      }
    }
  }
}

# Network Policy for ingress traffic (optional security)
resource "kubernetes_network_policy" "ingress_policy" {
  count = var.enable_network_policy ? 1 : 0

  metadata {
    name      = "${var.app_name}-ingress-policy"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        app = var.app_name
      }
    }

    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = var.ingress_namespace
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = "8080"
      }

      ports {
        protocol = "TCP"
        port     = "80"
      }
    }
  }
}
