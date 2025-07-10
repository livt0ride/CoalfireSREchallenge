# Variables
variable "vpc_id" {
  type = string
}

variable "app_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "app_sg_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}