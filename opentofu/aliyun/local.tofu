resource "local_file" "ansible-config" {
  content  = <<EOT
[defaults]
inventory = ./hosts.yaml
remote_user = root
private_key_file = ${pathexpand(var.ssh_private_key_path)}
host_key_checking = False
EOT
  filename = "${path.module}/../../ansible/ansible.cfg"
}

resource "local_file" "ansible-hosts" {
  content  = <<EOT
masters:
  hosts:
    master0:
      ansible_host: ${alicloud_instance.kubeadm-security-1m1w-master0.public_ip}
workers:
  hosts:
    worker0:
      ansible_host: ${alicloud_instance.kubeadm-security-1m1w-worker0.public_ip}
EOT
  filename = "${path.module}/../../ansible/hosts.yaml"
}
