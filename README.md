# kubeadm-security-1m1w

Kubeadm cluster with 1 master, 1 worker and sensible security defaults

## Dependencies

Ansible should be installed.

## Quickstart

Clone the repository and make it your working directory.

### Ansible configuration

Sample Ansible configuration file `ansible/ansible.cfg`:

```toml
[defaults]
inventory = ./hosts.yaml
remote_user = ubuntu
private_key_file = /path/to/your/id_ed25519
host_key_checking = False
```

### Ansible inventory

Sample Ansible inventory file `ansible/hosts.yaml`:

```yaml
masters:
  hosts:
    master0:
      ansible_host: x.x.x.x
workers:
  hosts:
    worker0:
      ansible_host: x.x.x.x
```

Replace `x.x.x.x` with IP addresses appropriate for your environment.

### Running the playbook

```bash
ANSIBLE_CONFIG="${PWD}/ansible/ansible.cfg" \
    ansible-playbook "${PWD}/ansible/playbook.yaml"
```

## License

[Apache 2.0](./LICENSE)
