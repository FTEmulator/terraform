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
                    image = "alpine:latest"
                    command = [
                        "sh", "-c",
                        <<-EOT
                        mkdir -p /sql
                        cat > /sql/01-init.sql << 'EOF'
                            DO $$
                            BEGIN
                                IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'profile') THEN
                                    CREATE DATABASE profile;
                                END IF;
                            END
                            $$;

                            DO $$
                            BEGIN
                                IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'profile_user') THEN
                                    CREATE USER profile_user WITH PASSWORD 'Almi123';
                                END IF;
                            END
                            $$;

                            \c profile;

                            CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

                            GRANT CONNECT ON DATABASE profile TO profile_user;
                            GRANT USAGE ON SCHEMA public TO profile_user;
                            GRANT CREATE ON SCHEMA public TO profile_user;

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

                            ALTER TABLE users OWNER TO profile_user;
                            GRANT ALL PRIVILEGES ON TABLE users TO profile_user;
                            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO profile_user;
                            EOF
                        EOT
                    ]

                    volume_mount {
                        name       = "init-sql"
                        mount_path = "/sql"
                    }

                    # Agregar recursos para evitar problemas de scheduling
                    resources {
                        requests = {
                            memory = "64Mi"
                            cpu    = "100m"
                        }
                        limits = {
                            memory = "128Mi"
                            cpu    = "200m"
                        }
                    }
                }

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

                    # Readiness probe para asegurar que postgres esté listo
                    readiness_probe {
                        exec {
                            command = ["pg_isready", "-U", "postgres", "-d", "postgres"]
                        }
                        initial_delay_seconds = 5
                        period_seconds        = 5
                        timeout_seconds       = 3
                        failure_threshold     = 3
                    }

                    # Liveness probe
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
                    }

                    volume_mount {
                        name       = "postgres-storage"
                        mount_path = "/var/lib/postgresql/data"
                    }

                    # Agregar recursos
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
                    empty_dir {}
                }

                # Agregar restart policy
                restart_policy = "Always"
            }
        }
    }
}