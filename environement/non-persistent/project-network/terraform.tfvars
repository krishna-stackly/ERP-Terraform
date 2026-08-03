project_name = "erp"
environment  = "qa"

############################################
# Existing shared infrastructure
############################################

vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

app_subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

database_security_group_id = "sg-xxxxxxxxxxxxxxxxx"

database_private_ip = "10.0.32.50"

database_port = 3306


############################################
# App
############################################

ami_id = "ami-xxxxxxxxxxxxxxxxx"

app_instance_type = "t3.large"
app_volume_size   = 50


############################################
# Internal DNS
############################################

private_zone_name = "internal"

database_dns_name    = "mysql-db.internal"
application_dns_name = "erp-qa.internal"


############################################
# Public access
############################################

http_ingress_cidr = "0.0.0.0/0"

enable_https = false


############################################
# Tags
############################################

common_tags = {
  Platform = "Shared-Dev"
  Owner    = "DevOps"
}