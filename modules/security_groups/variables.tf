# Variables
variable "vpc_id" {
  type = string
}

variable "management_cidr" {
  type = string
}

variable "management_sg_id" {
  type    = string
  default = ""
}

variable "alb_sg_id" {
  type    = string
  default = ""
}