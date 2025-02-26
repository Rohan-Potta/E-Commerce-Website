variable "ssh_key_name" {
  type        = string
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  default     = "null"
}

variable "project" {
  default     = "nemo"
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "securitygp-name" {
  type    = string
  default = "EC2Server-SG"
}

variable "environment" {
  default     = "trunk"
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "allocated_storage" {
  default     = 20
  type        = number
  description = "Storage allocated to database instance"
}

variable "database_engine" {
  type    = string
  default = "postgres"
}

variable "database_engine_version" {
  default     = "14.10"
  type        = string
  description = "Database engine version"
}

variable "database_instance_type" {
  default     = "db.t3.small"
  type        = string
  description = "Instance type for database instance"
}

variable "eks_nodes_instance_type" {
  default     = "t3a.large"
  type        = string
  description = "Instance type for eks nodes"
}

variable "kms_arn" {
  default = "arn:aws:kms:eu-central-1:851988726394:key/95ca433f-9838-4106-9bb3-d2501ccb6577"
  type    = string
}

variable "instance_name" {
  type    = string
  default = "trunk-jumpserver"
}

variable "storage_type" {
  default     = "gp2"
  type        = string
  description = "Type of underlying storage for database"
}

variable "iops" {
  default     = 0
  type        = number
  description = "The amount of provisioned IOPS"
}

variable "vpc_id" {
  default     = "vpc-0a152949600328e86"
  type        = string
  description = "ID of VPC meant to house database"
}

variable "snapshot_identifier" {
  default     = ""
  type        = string
  description = "The name of the snapshot (if any) the database should be created from"
}

variable "database_name" {
  default     = "tpctrunkdb"
  type        = string
  description = "Name of database inside storage engine"
}

variable "database_username" {
  default     = "postgres"
  type        = string
  description = "Name of user inside storage engine"
}

variable "database_password" {
  type        = string
  description = "Database password inside storage engine"
  sensitive   = true
}

variable "database_port" {
  default     = 5432
  type        = number
  description = "Port on which database will accept connections"
}

variable "database_parameter_group" {
  type    = string
  default = "trunk-database"
}

variable "database_subnet_group" {
  type    = string
  default = "trunk-database"
}

variable "secret_name" {
  type    = string
  default = "trunk-database"
}

variable "backup_retention_period" {
  default     = 30
  type        = number
  description = "Number of days to keep database backups"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default     = "04:00-04:30"
  type        = string
  description = "30 minute time window to reserve for backups"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  default     = "sun:04:30-sun:05:30"
  type        = string
  description = "60 minute time window to reserve for maintenance"
}

variable "auto_minor_version_upgrade" {
  default     = true
  type        = bool
  description = "Minor engine upgrades are applied automatically to the DB instance during the maintenance window"
}

variable "final_snapshot_identifier" {
  default     = "terraform-aws-postgresql-rds-snapshot"
  type        = string
  description = "Identifier for final snapshot if skip_final_snapshot is set to false"
}

variable "skip_final_snapshot" {
  default     = true
  type        = bool
  description = "Flag to enable or disable a snapshot if the database instance is terminated"
}

variable "copy_tags_to_snapshot" {
  default     = false
  type        = bool
  description = "Flag to enable or disable copying instance tags to the final snapshot"
}

variable "multi_availability_zone" {
  default     = false
  type        = bool
  description = "Flag to enable hot standby in another availability zone"
}

variable "storage_encrypted" {
  default     = false
  type        = bool
  description = "Flag to enable storage encryption"
}

variable "monitoring_interval" {
  default     = 0
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
}

variable "deletion_protection" {
  default     = false
  type        = bool
  description = "Flag to protect the database instance from deletion"
}

variable "cloudwatch_logs_exports" {
  default     = ["postgresql", "upgrade"]
  type        = list(any)
  description = "List of logs to publish to CloudWatch Logs"
}

variable "subnet_group" {
  default     = "nem-db-subnet"
  type        = string
  description = "Database subnet group"
}

variable "parameter_group" {
  default     = "default.postgres11"
  type        = string
  description = "Database engine parameter group"
}

variable "alarm_cpu_threshold" {
  default     = 75
  type        = number
  description = "CPU alarm threshold as a percentage"
}

variable "alarm_disk_queue_threshold" {
  default     = 10
  type        = number
  description = "Disk queue alarm threshold"
}

variable "alarm_free_disk_threshold" {
  # 5GB
  default     = 5000000000
  type        = number
  description = "Free disk alarm threshold in bytes"
}

variable "alarm_free_memory_threshold" {
  # 128MB
  default     = 128000000
  type        = number
  description = "Free memory alarm threshold in bytes"
}

variable "alarm_cpu_credit_balance_threshold" {
  default     = 30
  type        = number
  description = "CPU credit balance threshold (only for db.t* instance types)"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the RDS resources"
}

variable "database_identifier" {
  type    = string
  default = "tpctrunkdb"
}

variable "sns_topic_name" {
  type    = string
  default = "user-updates-topic"
}
variable "sqs_queue_name" {
  type    = string
  default = "terraform-example-queue"
}
variable "sqs_deadletter_name" {
  type    = string
  default = "terraform-deadletter-queue"
}

variable "email" {
  type    = string
  default = "sushmathamma@gmail.com"
}

variable "route53_zone_name" {
  type    = string
  default = "example.net"
}

variable "route53_record_name" {
  type    = string
  default = "test.example.net"
}

variable "cname_record_values" {
  type    = string
  default = ""
}

variable "cloudwatch_event_rule_name" {
  default = "capture-aws-sign-in"
  type    = string
}

variable "event_sns_topic_name" {
  default = "aws-console-logins"
  type    = string
}

variable "iam_for_trunk_drivewealth-auth-token-function" {
  default = "drivewealth-auth-token-function-role-trunk"
  type    = string
}

variable "file_name" {
  default = "lambda_function_payload"
  type    = string
}

variable "lambda_function_name" {
  default = "lambda_function"
  type    = string
}

variable "lambda_bucket_name" {
  default = "terr-bucket-svkpl-ts"
  type    = string
}

variable "rest_api_name" {
  type        = string
  description = "Name of the API Gateway created"
  default     = "terraform-api-gateway-example"
}

variable "ports" {
  type = map(number)
  default = {
    http  = 80
    https = 443
  }
}

variable "iam_for_trunk_drivewealth-bulk-funding" {
  default = "drivewealth-bulk-funding-trunk"
  type    = string
}

variable "iam_policy_for_trunk_drivewealth-bulk-funding" {
  default = "AWSLambdaBasicExecutionRoleDrivewealth-bulk-funding-trunk"
  type    = string
}

variable "lambda_name_drivewealth-bulk-funding" {
  default = "drivewealth-bulk-funding"
  type    = string
}


variable "iam_policy_for_trunk_drivewealth-auth-token-function" {
  default = "AWSLambdaBasicExecutionRoleDrivewealth-auth-trunk"
  type    = string
}

variable "lambda_name_drivewealth-auth-token-function" {
  default = "drivewealth-auth-token-function"
  type    = string
}

variable "iam_for_trunk_instrumentmarketdata" {
  default = "instrumentmarketdata-role"
  type    = string
}

variable "iam_policy_for_trunk_instrumentmarketdata" {
  default = "AWSLambdaBasicExecutionRoleInstrumentmarketdata"
  type    = string
}

variable "lambda_name_instrumentmarketdata" {
  default = "instrumentmarketdata"
  type    = string
}

variable "iam_for_trunk_instrumentdata" {
  default = "instrumentdata-role"
  type    = string
}

variable "iam_policy_for_trunk_instrumentdata" {
  default = "AWSLambdaBasicExecutionRoleInstrumentdata"
  type    = string
}

variable "lambda_name_instrumentdata" {
  default = "instrumentdata"
  type    = string
}


variable "iam_for_trunk_leantech-payment-source-webhook-function" {
  default = "leantech-payment-source-webhook-function-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_leantech-payment-source-webhook-function" {
  default = "AWSLambdaBasicExecutionRoleLeantech-payment-source-trunk"
  type    = string
}

variable "lambda_name_leantech-payment-source-webhook-function" {
  default = "leantech-payment-source-webhook-function-trunk"
  type    = string
}


variable "iam_for_trunk_exinity-sumsub-webhook-lamdba-trunk" {
  default = "exinity-sumsub-webhook-lamdba-trunk-role"
  type    = string
}

variable "iam_policy_for_trunk_exinity-sumsub-webhook-lamdba-trunk" {
  default = "AWSLambdaBasicExecutionRoleExinity-sumsub-webhook-trunk"
  type    = string
}

variable "lambda_name_exinity-sumsub-webhook-lamdba-trunk" {
  default = "exinity-sumsub-webhook-lamdba-trunk"
  type    = string
}


variable "iam_for_trunk_keycloak-offline-authorizer" {
  default = "keycloak-offline-authorizer-role-trunk"
  type    = string
}

variable "iam_for_trunk_marketrealtime" {
  default = "marketrealtime-role"
  type    = string
}

variable "iam_policy_for_trunk_marketrealtime" {
  default = "AWSLambdaBasicExecutionRolemarketrealtime"
  type    = string
}

variable "iam_policy_for_trunk_keycloak-offline-authorizer" {
  default = "AWSLambdaBasicExecutionRoleKeycloak-offline-authorizer-trunk"
  type    = string
}


variable "lambda_name_keycloak-offline-authorizer" {
  default = "keycloak-offline-authorizer"
  type    = string
}


variable "iam_for_trunk_exinity-mparticle" {
  default = "exinity-mparticle-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_exinity-mparticle" {
  default = "AWSLambdaBasicExecutionRoleExinity-mparticle-trunk"
  type    = string
}

variable "lambda_name_exinity-mparticle" {
  default = "exinity-mparticle"
  type    = string
}


variable "iam_for_trunk_exinity-drivewealth-user-onboard-function" {
  default = "exinity-drivewealth-user-onboard-function-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_exinity-drivewealth-user-onboard-function" {
  default = "AWSLambdaBasicExecutionRoleExinity-drivewealth-user-trunk"
  type    = string
}

variable "lambda_name_exinity-drivewealth-user-onboard-function" {
  default = "exinity-drivewealth-user-onboard-function"
  type    = string
}


variable "iam_for_trunk_exinity-sumsub-retry-getstatus-function" {
  default = "exinity-sumsub-retry-getstatus-function-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_exinity-sumsub-retry-getstatus-function" {
  default = "AWSLambdaBasicExecutionRoleExinity-sumsub-retry-trunk"
  type    = string
}

variable "lambda_name_exinity-sumsub-retry-getstatus-function" {
  default = "exinity-sumsub-retry-getstatus-function"
  type    = string
}


variable "iam_for_trunk_withdrawal-transaction-report-generator" {
  default = "withdrawal-transaction-report-generator-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_withdrawal-transaction-report-generator" {
  default = "AWSLambdaBasicExecutionRoleWithdrawal-transaction-trunk"
  type    = string
}

variable "lambda_name_withdrawal-transaction-report-generator" {
  default = "withdrawal-transaction-report-generator"
  type    = string
}


variable "iam_for_trunk_send-report-notification-mail" {
  default = "send-report-notification-mail-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_send-report-notification-mail" {
  default = "AWSLambdaBasicExecutionRoleSend-report-notification-trunk"
  type    = string
}

variable "lambda_name_send-report-notification-mail" {
  default = "send-report-notification-mail"
  type    = string
}


variable "iam_for_trunk_keycloak-authorizer" {
  default = "keycloak-authorizer-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_keycloak-authorizer" {
  default = "AWSLambdaBasicExecutionRoleKeycloak-authorizer-trunk"
  type    = string
}

variable "lambda_name_keycloak-authorizer" {
  default = "keycloak-authorizer"
  type    = string
}

variable "iam_for_trunk_DWAuthTokenInit" {
  default = "DWAuthTokenInit-role"
  type    = string
}

variable "iam_policy_for_trunk_DWAuthTokenInit" {
  default = "AWSLambdaBasicExecutionRoleDWAuthTokenInit"
  type    = string
}

variable "lambda_name_DWAuthTokenInit" {
  default = "DWAuthTokenInit"
  type    = string
}

variable "iam_for_trunk_leantech-fetch-banks-function" {
  default = "leantech-fetch-banks-function-role"
  type    = string
}

variable "iam_policy_for_trunk_leantech-fetch-banks-function" {
  default = "AWSLambdaBasicExecutionRoleleantech-fetch-banks-function"
  type    = string
}

variable "lambda_name_leantech-fetch-banks-function" {
  default = "leantech-fetch-banks-function"
  type    = string
}

variable "iam_for_trunk_dw-others" {
  default = "dw-others-role"
  type    = string
}

variable "iam_policy_for_trunk_dw-others" {
  default = "AWSLambdaBasicExecutionRoledw-others"
  type    = string
}

variable "lambda_name_dw-others" {
  default = "dw-others"
  type    = string
}

variable "iam_for_trunk_dw-portfolio" {
  default = "dw-portfolio-role"
  type    = string
}

variable "iam_policy_for_trunk_dw-portfolio" {
  default = "AWSLambdaBasicExecutionRoledw-portfolio"
  type    = string
}

variable "lambda_name_dw-portfolio" {
  default = "dw-portfolio"
  type    = string
}

variable "iam_for_trunk_dw-orders" {
  default = "dw-orders-role"
  type    = string
}

variable "iam_policy_for_trunk_dw-orders" {
  default = "AWSLambdaBasicExecutionRoledw-orders"
  type    = string
}

variable "lambda_name_dw-orders" {
  default = "dw-orders"
  type    = string
}

variable "iam_for_trunk_dw-accounts" {
  default = "dw-accounts-role"
  type    = string
}

variable "iam_policy_for_trunk_dw-accounts" {
  default = "AWSLambdaBasicExecutionRoledw-accounts"
  type    = string
}

variable "lambda_name_dw-accounts" {
  default = "dw-accounts"
  type    = string
}


variable "lambda_name_marketrealtime" {
  default = "marketrealtime"
  type    = string
}

variable "iam_for_trunk_exinity-leantech-user-onboard-function" {
  default = "exinity-leantech-user-onboard-function-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_exinity-leantech-user-onboard-function" {
  default = "AWSLambdaBasicExecutionRoleExinity-leantech-user-trunk"
  type    = string
}

variable "lambda_name_exinity-leantech-user-onboard-function" {
  default = "exinity-leantech-user-onboard-function"
  type    = string
}


variable "iam_for_trunk_report-fail-notification-mail" {
  default = "report-fail-notification-mail-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_report-fail-notification-mail" {
  default = "AWSLambdaBasicExecutionRoleReport-fail-notification-mail-trunk"
  type    = string
}

variable "lambda_name_report-fail-notification-mail" {
  default = "report-fail-notification-mail"
  type    = string
}


variable "iam_for_trunk_exinity-mparticle-lambda" {
  default = "exinity-mparticle-lambda-role-trunk"
  type    = string
}

variable "iam_policy_for_trunk_exinity-mparticle-lambda" {
  default = "AWSLambdaBasicExecutionRoleExinity-mparticle-lambda-trunk"
  type    = string
}

variable "lambda_name_exinity-mparticle-lambda" {
  default = "exinity-mparticle-lambda"
  type    = string
}
