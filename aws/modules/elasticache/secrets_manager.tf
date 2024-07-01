# ***************************************
# Secrets Manager - RDS Credential Storage
# ***************************************
resource "random_string" "secretsmanager" {
  length  = 8
  special = false
}

# Generate initial random passwords for Chirpstack Redis users
resource "random_password" "redis_default_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$?"
}

resource "random_password" "redis_chirpstack_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$?"
}

# Initialize AWS Secret Manager entry for the Chirpstack Redis user credentials
resource "aws_secretsmanager_secret" "redis_default_credentials" {
  name        = "redis-default-credentials-${random_string.secretsmanager.result}"
  description = "Credentials for Redis default user (e.g., Admin)"
}

resource "aws_secretsmanager_secret" "redis_chirpstack_credentials" {
  name        = "redis-chirpstack-credentials-${random_string.secretsmanager.result}"
  description = "Credentials for Redis chirpstack user"
}

# Apply the Chirpstack Redis user credentials to the AWS Secret Manager entries
resource "aws_secretsmanager_secret_version" "redis_default_vals" {
  secret_id = aws_secretsmanager_secret.redis_default_credentials.id
  secret_string = jsonencode(
    {
      "password" : random_password.redis_default_password.result,
      "username" : "default",
      "user_arn" : "arn:aws:elasticache:${var.aws_region}:${data.aws_caller_identity.current.account_id}:user:default"
    }
  )
}

resource "aws_secretsmanager_secret_version" "redis_chirpstack_vals" {
  secret_id = aws_secretsmanager_secret.redis_chirpstack_credentials.id
  secret_string = jsonencode(
    {
      "password" : random_password.redis_chirpstack_password.result,
      "username" : "chirpstack",
      "user_arn" : "arn:aws:elasticache:${var.aws_region}:${data.aws_caller_identity.current.account_id}:user:chirpstack",
    }
  )
}
