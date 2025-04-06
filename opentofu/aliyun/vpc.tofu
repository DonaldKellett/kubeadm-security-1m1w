resource "alicloud_vpc" "kubeadm-security-1m1w-vpc" {
  vpc_name   = "kubeadm-security-1m1w-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "kubeadm-security-1m1w-vswitch" {
  vswitch_name = "kubeadm-security-1m1w-vswitch"
  cidr_block   = var.vswitch_cidr
  vpc_id       = alicloud_vpc.kubeadm-security-1m1w-vpc.id
  zone_id      = data.alicloud_zones.kubeadm-security-1m1w-zones.zones.0.id
}
