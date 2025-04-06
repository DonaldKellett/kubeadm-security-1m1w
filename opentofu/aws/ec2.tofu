resource "aws_key_pair" "kubeadm-security-1m1w-ssh-key" {
  key_name   = "kubeadm-security-1m1w-ssh-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "aws_launch_template" "kubeadm-security-1m1w-master-launch-template" {
  name          = "kubeadm-security-1m1w-master-launch-template"
  image_id      = data.aws_ami.ubuntu-noble.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kubeadm-security-1m1w-ssh-key.key_name
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.kubeadm-security-1m1w-subnet.id
    security_groups = [
      aws_security_group.kubeadm-security-1m1w-masters-sg.id
    ]
  }
}

resource "aws_launch_template" "kubeadm-security-1m1w-worker-launch-template" {
  name          = "kubeadm-security-1m1w-worker-launch-template"
  image_id      = data.aws_ami.ubuntu-noble.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kubeadm-security-1m1w-ssh-key.key_name
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.kubeadm-security-1m1w-subnet.id
    security_groups = [
      aws_security_group.kubeadm-security-1m1w-workers-sg.id
    ]
  }
}

resource "aws_instance" "kubeadm-security-1m1w-master0" {
  launch_template {
    id      = aws_launch_template.kubeadm-security-1m1w-master-launch-template.id
    version = "$Latest"
  }
  root_block_device {
    volume_size = var.sys_volume_size
  }
  tags = {
    Name = "kubeadm-security-1m1w-master0"
  }
}

resource "aws_instance" "kubeadm-security-1m1w-worker0" {
  launch_template {
    id      = aws_launch_template.kubeadm-security-1m1w-worker-launch-template.id
    version = "$Latest"
  }
  root_block_device {
    volume_size = var.sys_volume_size
  }
  tags = {
    Name = "kubeadm-security-1m1w-worker0"
  }
}
