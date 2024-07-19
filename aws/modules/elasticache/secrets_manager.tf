# ***************************************
# Secrets Manager - RDS Credential Storage
# ***************************************

# Generate initial random passwords for Chirpstack Redis users
resource "random_password" "redis_default_password" {
  length  = 40
  special = false
}

resource "random_password" "redis_chirpstack_password" {
  length  = 40
  special = false
}

resource "random_password" "redis_helium_password" {
  length  = 40
  special = false
}

# Initialize AWS Secret Manager entry for the Chirpstack Redis user credentials
resource "aws_secretsmanager_secret" "redis_default_credentials" {
  name        = "root/redis-default-credentials"
  description = "Credentials for Redis default user (e.g., Admin)"
}

resource "aws_secretsmanager_secret" "redis_chirpstack_credentials" {
  name        = "chirpstack/redis-chirpstack-credentials"
  description = "Credentials for Redis chirpstack user"
}

resource "aws_secretsmanager_secret" "redis_helium_credentials" {
  name        = "chirpstack/redis-helium-credentials"
  description = "Credentials for Redis helium user"
}

# Apply the Chirpstack Redis user credentials to the AWS Secret Manager entries
resource "aws_secretsmanager_secret_version" "redis_default_vals" {
  secret_id = aws_secretsmanager_secret.redis_default_credentials.id
  secret_string = jsonencode(
    {
      "password" : random_password.redis_default_password.result,
      "username" : "default",
      "host" : aws_elasticache_replication_group.this.primary_endpoint_address
    }
  )
}

resource "aws_secretsmanager_secret_version" "redis_chirpstack_vals" {
  secret_id = aws_secretsmanager_secret.redis_chirpstack_credentials.id
  secret_string = jsonencode(
    {
      "password" : random_password.redis_chirpstack_password.result,
      "username" : "chirpstack",
      "host" : aws_elasticache_replication_group.this.primary_endpoint_address
    }
  )
}

resource "aws_secretsmanager_secret_version" "redis_helium_vals" {
  secret_id = aws_secretsmanager_secret.redis_helium_credentials.id
  secret_string = jsonencode(
    {
      "password" : random_password.redis_helium_password.result,
      "username" : "helium",
      "host" : aws_elasticache_replication_group.this.primary_endpoint_address
    }
  )
}
