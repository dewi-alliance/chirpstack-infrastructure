# ***************************************
# Secrets Manager - RDS Credential Storage
# ***************************************
resource "random_string" "secretsmanager" {
  length  = 8
  special = false
}

# Generate initial random password for Chirpstack RDS postgres admin user
resource "random_password" "pg_admin_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#&?"
}

# Initialize AWS Secret Manager entry for the Chirpstack RDS postgres admin credentials
resource "aws_secretsmanager_secret" "pg_credentials" {
  name        = "postgres-chirpstack-admin-credentials-${random_string.secretsmanager.result}"
  description = "Admin credentials for Chirpstack PostgreSQL database"
}

# Apply the Chirpstack RDS postgres admin credentials to the AWS Secret Manager entry
resource "aws_secretsmanager_secret_version" "pg_credentials_vals" {
  secret_id = aws_secretsmanager_secret.pg_credentials.id
  secret_string = jsonencode(
    {
      engine   = "postgres"
      host     = aws_db_instance.rds.address
      username = aws_db_instance.rds.username
      dbname   = aws_db_instance.rds.db_name
      port     = aws_db_instance.rds.port
      password = random_password.pg_admin_password.result
    }
  )
}

# Configure Chirpstack RDS postgres admin password rotation schedule
resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = aws_secretsmanager_secret_version.pg_credentials_vals.secret_id
  rotation_lambda_arn = aws_serverlessapplicationrepository_cloudformation_stack.rotator_cf_stack.outputs.RotationLambdaARN

  rotation_rules {
    automatically_after_days = 30
  }
}

# ***************************************
# Lambda - RDS credential rotator
# ***************************************

# For the automated Chirpstack RDS posgres password rotation, we are using the AWS-provided CloudFormation stack noted below
resource "aws_serverlessapplicationrepository_cloudformation_stack" "rotator_cf_stack" {
  name             = "chirpstack-rds-pg-credential-rotator-stack"
  application_id   = data.aws_serverlessapplicationrepository_application.rotator.application_id
  semantic_version = data.aws_serverlessapplicationrepository_application.rotator.semantic_version
  capabilities     = data.aws_serverlessapplicationrepository_application.rotator.required_capabilities

  parameters = {
    endpoint            = "https://secretsmanager.${var.aws_region}.${data.aws_partition.current.dns_suffix}"
    functionName        = "chirpstack-rds-pg-credential-rotator"
    vpcSubnetIds        = join(",", var.database_subnet_ids)
    vpcSecurityGroupIds = "${aws_security_group.secrets_manager_rotator_lambda_security_group.id},${aws_security_group.rds_access_security_group.id}"
  }
}

# ***************************************
# VPC Endpoint
# VPCE for rotator Lambda to connect to Secrets Manager
# ***************************************
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.database_subnet_ids
  security_group_ids  = [aws_security_group.secrets_manager_vpc_endpoint_security_group.id]
}

# ***************************************
# Security Group
# Secrets manager VPC endpoint security group
# ***************************************
resource "aws_security_group" "secrets_manager_vpc_endpoint_security_group" {
  name        = "secrets-manager-vpc-endpoint-security-group"
  description = "Security group for Secrets Manager VPC endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.secrets_manager_rotator_lambda_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secrets-manager-vpc-endpoint-security-group"
  }
}

# ***************************************
# Security Group
# Secrets Manager rotator lambda security group
# ***************************************
resource "aws_security_group" "secrets_manager_rotator_lambda_security_group" {
  name        = "secrets-manager-rotator-lambda-security-group"
  description = "Security group required for rotator Lambda to access Secrets Manager VPC endpoint"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secrets-manager-rotator-lambda-security-group"
  }
}
