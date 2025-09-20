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
                    image = "postgres:17"

                    port {
                        container_port = 5432
                    }

                    env {
                        name  = "POSTGRES_DB"
                        value = "postgres"
                    }

                    env {
                        name  = "POSTGRES_USER"
                        value = "postgres"
                    }

                    env {
                        name = "POSTGRES_PASSWORD"
                        value = "Almi123"
                    }

                    env {
                        name  = "PGDATA"
                        value = "/var/lib/postgresql/data/pgdata"
                    }

                    readiness_probe {
                        exec {
                            command = ["pg_isready", "-U", "postgres", "-d", "postgres"]
                        }
                        initial_delay_seconds = 5
                        period_seconds        = 5
                        timeout_seconds       = 3
                        failure_threshold     = 3
                    }

                    liveness_probe {
                        exec {
                            command = ["pg_isready", "-U", "postgres", "-d", "postgres"]
                        }
                        initial_delay_seconds = 30
                        period_seconds        = 10
                        timeout_seconds       = 5
                        failure_threshold     = 3
                    }

                    volume_mount {
                        name       = "init-sql"
                        mount_path = "/docker-entrypoint-initdb.d"
                        read_only = true
                    }

                    volume_mount {
                        name       = "postgres-storage"
                        mount_path = "/var/lib/postgresql/data"
                    }

                    resources {
                        requests = {
                            memory = "256Mi"
                            cpu    = "250m"
                        }
                        limits = {
                            memory = "512Mi"
                            cpu    = "500m"
                        }
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
                    config_map {
                        name = kubernetes_config_map.postgres_init_sql.metadata[0].name
                    }
                }

                restart_policy = "Always"
            }
        }
    }
}

# Create a ConfigMap with the initialization SQL
resource "kubernetes_config_map" "postgres_init_sql" {
  metadata {
    name      = "postgres-init-sql"
    namespace = kubernetes_namespace.profile.metadata[0].name
  }

  data = {
    "01-init.sql" = <<-EOT
      -- Crear la base de datos si no existe
      SELECT 'CREATE DATABASE profile'
      WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'profile')\gexec
      
      -- Crear el usuario si no existe
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'profile_user') THEN
            CREATE USER profile_user WITH PASSWORD 'Almi123';
        END IF;
      END
      $$;
    EOT

    "02-schema.sql" = <<-EOT
      -- Conectarse a la base de datos profile y crear el esquema
      \connect profile;
      
      -- Crear la extensión UUID
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      
      -- Otorgar permisos al usuario
      GRANT CONNECT ON DATABASE profile TO profile_user;
      GRANT USAGE ON SCHEMA public TO profile_user;
      GRANT CREATE ON SCHEMA public TO profile_user;
      
      -- Crear la tabla users
      CREATE TABLE IF NOT EXISTS users (
          id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
          name varchar(20) NOT NULL UNIQUE,
          email varchar(50) NOT NULL UNIQUE,
          password varchar(100) NOT NULL,
          country varchar(50) NOT NULL,
          experience int2,
          photo varchar(100),
          biography varchar(1000)
      );
      
      -- Otorgar permisos sobre la tabla
      ALTER TABLE users OWNER TO profile_user;
      GRANT ALL PRIVILEGES ON TABLE users TO profile_user;
      
      -- Otorgar permisos por defecto
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO profile_user;
    EOT
  }
}