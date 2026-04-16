variable "environment" {
  type = string
  default = "production"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "base_domain_name" {
  type    = string
  default = "alanen.dev"
}

variable "domain_name" {
  type    = string
  default = "product-analytics-t6-2"
}