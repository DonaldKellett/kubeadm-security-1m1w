output "kubeadm-security-1m1w-master0-public-ip" {
  value = aws_instance.kubeadm-security-1m1w-master0.public_ip
}

output "kubeadm-security-1m1w-worker0-public-ip" {
  value = aws_instance.kubeadm-security-1m1w-worker0.public_ip
}
