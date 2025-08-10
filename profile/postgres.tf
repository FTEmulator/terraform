# Generador de usuarios y contrasenas
resource "random_string" "user" {
  length           = 10
  special          = false
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Configuracion sql
resource "kubernetes_config_map" "init_sql" {
  metadata {
    name      = "postgres-init-sql"
    namespace = kubernetes_namespace.profile.metadata[0].name
  }

  data = {
    "postgres.sql" = <<EOF
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        CREATE TABLE users (
            id 		uuid primary key default uuid_generate_v4(),	
            name		varchar(20) NOT NULL UNIQUE,
            email		varchar(50) NOT NULL UNIQUE,
            password	varchar(100) NOT NULL,
            country		varchar(50) NOT NULL,
            experience	int2,
            photo		varchar(100),
            biography	varchar(1000)
        );
    EOF
  }
}


# Despliege de Postgresql
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.profile.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = "profile"
          }

          env {
            name  = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_credentials.metadata[0].name
                key = "username"
              }
            }
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_credentials.metadata[0].name
                key = "password"
              }
            }
          }

          volume_mount {
            name       = "init-sql"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          volume_mount {
            name = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "init-sql"

          config_map {
            name = kubernetes_config_map.init_sql.metadata[0].name
          }
        }

        volume {
            name = "postgres-storage"

            persistent_volume_claim {
                claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
            }
        }
      }
    }
  }
}
