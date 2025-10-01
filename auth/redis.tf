# =======================
# ConfigMap con redis.conf base
# =======================
resource "kubernetes_config_map" "redis_config" {
  metadata {
    name      = "redis-config"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  data = {
    "redis.conf" = <<EOF
# Data directory
dir /data

# Persistence
save 900 1
save 300 10
save 60 100

# AOF configuration
appendonly yes
appendfsync everysec
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# Memory management
maxmemory 512mb
maxmemory-policy allkeys-lru

# Network configuration
tcp-keepalive 60
timeout 300
bind 0.0.0.0
port 6379

# Security
protected-mode no

# Logging
loglevel notice
logfile ""

# Session optimization
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
EOF
  }
}

# =======================
# ConfigMap con entrypoint wrapper
# =======================
resource "kubernetes_config_map" "redis_entrypoint" {
  metadata {
    name      = "redis-entrypoint"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  data = {
    "entrypoint.sh" = <<-EOT
      #!/bin/sh
      set -e
      cp /usr/local/etc/redis/redis.conf /tmp/redis.conf
      echo "requirepass $REDIS_PASSWORD" >> /tmp/redis.conf
      exec redis-server /tmp/redis.conf
    EOT
  }
}

# =======================
# Deployment de Redis
# =======================
resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace.auth.metadata[0].name
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = var.auth_redis_image

          command = ["/bin/sh", "/docker-entrypoint-init/entrypoint.sh"]

          port {
            container_port = var.auth_redis_port
          }

          # Variables de entorno
          env {
            name  = "REDIS_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_credentials.metadata[0].name
                key  = "password"
              }
            }
          }

          # Probes
          liveness_probe {
            tcp_socket {
              port = var.auth_redis_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = var.auth_redis_port
            }
            initial_delay_seconds = 5
          }

          # Volúmenes
          volume_mount {
            name       = "auth-storage"
            mount_path = "/data"
            sub_path   = "redisstorage"
          }

          volume_mount {
            name       = "redis-config"
            mount_path = "/usr/local/etc/redis"
            read_only  = true
          }

          volume_mount {
            name       = "redis-entrypoint"
            mount_path = "/docker-entrypoint-init"
            read_only  = true
          }
        }

        # Volúmenes declarados
        volume {
          name = "auth-storage"
          host_path {
            path = "/mnt/auth"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "redis-config"
          config_map {
            name = kubernetes_config_map.redis_config.metadata[0].name
          }
        }

        volume {
          name = "redis-entrypoint"
          config_map {
            name = kubernetes_config_map.redis_entrypoint.metadata[0].name
            default_mode = "0755"
          }
        }
      }
    }
  }
}
