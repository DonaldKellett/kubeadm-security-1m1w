variable "trusted_cidr_blocks" {
  type = list(string)
}

variable "region" {
  type    = string
  default = "ap-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "sys_volume_size" {
  type    = number
  default = 64
}
