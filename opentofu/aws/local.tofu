resource "local_file" "kubeadm-security-1m1w-ansible-config" {
  content         = <<EOT
[defaults]
inventory = ./hosts.yaml
remote_user = ubuntu
private_key_file = ${pathexpand(var.ssh_public_key_path)}
host_key_checking = False
EOT
  filename        = "${path.module}/../../ansible/ansible.cfg"
  file_permission = "0600"
}

resource "local_file" "kubeadm-security-1m1w-ansible-inventory" {
  content         = <<EOT
masters:
  hosts:
    master0:
      ansible_host: ${aws_instance.kubeadm-security-1m1w-master0.public_ip}
workers:
  hosts:
    worker0:
      ansible_host: ${aws_instance.kubeadm-security-1m1w-worker0.public_ip}
EOT
  filename        = "${path.module}/../../ansible/hosts.yaml"
  file_permission = "0600"
}
