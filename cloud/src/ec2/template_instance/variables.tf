variable "deployed_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "app_db_instance_identifier" {
  type        = string
  description = "id of test db"
  default     = "appdbpostgres"
}

variable "app_db_instance_class" {
  type        = string
  description = "type of test db"
  default     = "db.t2.micro"
}

variable "app_db_name" {
  type        = string
  description = "test db name"
  default     = "appdb"
}

variable "app_db_user" {
  type        = string
  description = "test db user"
  default     = "appdbuser"
}

variable "app_db_password" {
  type        = string
  description = "test db password"
  default     = "appdbpassword"
}

variable "db_max_connections" {
  type    = number
  default = 300
}

variable "deployed_ami_base_image" {
  type        = string
  description = "official ubuntu 18 image"
  default     = "ami-05801d0a3c8e4c443"
}

variable "deployed_instance_type" {
  type        = string
  description = "type of instances to deploy for migration instance, template instance and target group instances"
  default     = "t2.micro"
}

variable "ssh_pub_key" {
  type        = string
  description = "pub key to be added to instances"
  default = ""
}

variable "app_ready_check_path" {
  type        = string
  description = "path to determine ec2 instance health"
  default     = "/welcome/default/date_time"
}

