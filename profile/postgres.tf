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
        init_container {
          name  = "generate-init-sql"
          image = "alpine"
          command = [
            "sh", "-c",
            <<-EOT
              mkdir -p /sql
              echo "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'profile') THEN CREATE DATABASE profile; END IF; END \$\$;" > /sql/postgres.sql
              echo "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'profile_user') THEN CREATE USER profile_user WITH PASSWORD 'Almi123'; END IF; END \$\$;" >> /sql/postgres.sql
              echo "GRANT CONNECT ON DATABASE profile TO profile_user;" >> /sql/postgres.sql
              echo "GRANT USAGE ON SCHEMA public TO profile_user;" >> /sql/postgres.sql
              echo "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO profile_user;" >> /sql/postgres.sql
              echo "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO profile_user;" >> /sql/postgres.sql
              echo "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";" >> /sql/postgres.sql
              echo "CREATE TABLE IF NOT EXISTS users (id uuid primary key default uuid_generate_v4(), name varchar(20) NOT NULL UNIQUE, email varchar(50) NOT NULL UNIQUE, password varchar(100) NOT NULL, country varchar(50) NOT NULL, experience int2, photo varchar(100), biography varchar(1000));" >> /sql/postgres.sql
            EOT
          ]

          volume_mount {
            name       = "init-sql"
            mount_path = "/sql"
          }
        }

        container {
          name  = "postgres"
          image = "postgres:latest"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "Almi123"
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
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }

        volume {
          name = "init-sql"
          empty_dir {}
        }
      }
    }
  }
}
