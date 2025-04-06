variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "trusted_cidr_block" {
  type = string
}

variable "region" {
  type    = string
  default = "cn-hongkong"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vswitch_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "instance_type" {
  type    = string
  default = "ecs.g8i.large"
}

variable "system_disk_size" {
  type    = number
  default = 64
}

variable "ssh_private_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519"
}
