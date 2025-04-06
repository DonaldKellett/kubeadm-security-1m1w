resource "alicloud_security_group" "kubeadm-security-1m1w-sg" {
  security_group_name = "kubeadm-security-1m1w-sg"
  vpc_id              = alicloud_vpc.kubeadm-security-1m1w-vpc.id
}

resource "alicloud_security_group_rule" "kubeadm-security-1m1w-sg-ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.kubeadm-security-1m1w-sg.id
  cidr_ip           = var.trusted_cidr_block
}

resource "alicloud_security_group_rule" "kubeadm-security-1m1w-sg-egress" {
  type              = "egress"
  ip_protocol       = "all"
  port_range        = "-1/-1"
  security_group_id = alicloud_security_group.kubeadm-security-1m1w-sg.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_ecs_key_pair" "kubeadm-security-1m1w-node-ssh-pubkey" {
  key_pair_name = "kubeadm-security-1m1w-node-ssh-pubkey"
  public_key    = file(pathexpand(var.ssh_public_key_path))
}

resource "alicloud_ecs_launch_template" "kubeadm-security-1m1w-node-lt" {
  launch_template_name          = "kubeadm-security-1m1w-node-lt"
  image_id                      = data.alicloud_images.ubuntu.images.0.id
  instance_charge_type          = "PostPaid"
  instance_type                 = var.instance_type
  key_pair_name                 = alicloud_ecs_key_pair.kubeadm-security-1m1w-node-ssh-pubkey.key_pair_name
  security_enhancement_strategy = "Active"
  security_group_ids            = [alicloud_security_group.kubeadm-security-1m1w-sg.id]

  vswitch_id = alicloud_vswitch.kubeadm-security-1m1w-vswitch.id
  vpc_id     = alicloud_vpc.kubeadm-security-1m1w-vpc.id
  zone_id    = data.alicloud_zones.kubeadm-security-1m1w-zones.zones.0.id

  network_interfaces {
    security_group_id = alicloud_security_group.kubeadm-security-1m1w-sg.id
    vswitch_id        = alicloud_vswitch.kubeadm-security-1m1w-vswitch.id
  }
}

resource "alicloud_instance" "kubeadm-security-1m1w-master0" {
  instance_name      = "kubeadm-security-1m1w-master0"
  launch_template_id = alicloud_ecs_launch_template.kubeadm-security-1m1w-node-lt.id
  host_name          = "master0"

  internet_charge_type       = "PayByBandwidth"
  internet_max_bandwidth_out = 5

  system_disk_size     = tostring(var.system_disk_size)
  system_disk_category = "cloud_essd"
}

resource "alicloud_instance" "kubeadm-security-1m1w-worker0" {
  instance_name      = "kubeadm-security-1m1w-worker0"
  launch_template_id = alicloud_ecs_launch_template.kubeadm-security-1m1w-node-lt.id
  host_name          = "worker0"

  internet_charge_type       = "PayByBandwidth"
  internet_max_bandwidth_out = 5

  system_disk_size     = tostring(var.system_disk_size)
  system_disk_category = "cloud_essd"
}
