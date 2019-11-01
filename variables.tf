variable "aws_vpc_id" {
  description = "VPC ID"
}

variable "aws_cluster_name" {
  description = "Name of Cluster"
}

variable "aws_vpc_cidr_block" {
  description = "CIDR Block for VPC"
}

variable "aws_subnet_ids" {
  description = "IDs of Public Subnets"
  type        = list(string)
}

variable "aws_lb_proxy_port" {
  description = "Port for AWS LB"
}

variable "fusion_secure_proxy_port" {
  description = "Secure Port of Fusion Proxy Servers"
}

variable "aws_avail_zones" {
  description = "Availability Zones Used"
  type        = list(string)
}

variable "aws_lb_logs_s3_bucket" {
  description = "S3 Bucket LB Logs"
}

variable "default_tags" {
  description = "Tags for all resources"
  type        = map(string)
}

