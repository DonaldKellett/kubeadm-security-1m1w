data "alicloud_zones" "kubeadm-security-1m1w-zones" {
  available_resource_creation = "VSwitch"
}

data "alicloud_images" "ubuntu" {
  name_regex = "^ubuntu_24_04_x64*"
  owners     = "system"
}
