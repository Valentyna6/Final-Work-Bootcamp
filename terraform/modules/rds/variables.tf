variable "subnets" { type = list(string) }
variable "rds_sg_id" { type = string }
variable "db_name" { type = string }
variable "db_user" { type = string }
variable "db_pass" {
  type      = string
  sensitive = true
}

