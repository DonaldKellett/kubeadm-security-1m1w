# kubeadm-security-1m1w

Kubeadm cluster with 1 master, 1 worker and sensible security defaults

## Dependencies

Ansible should be installed.

If using your own infrastructure, ensure you have SSH access to 2 nodes with the following specifications:

- OS: Ubuntu 24.04 LTS \(Jammy\)
- Architecture: `amd64`
- vCPU: at least 2
- Memory \(GiB\): at least 8
- Storage \(GiB\): at least 64

## Components

The following software components are installed.

### Kubernetes components

The installed components below are critical to Kubernetes operation.

| Name | Version |
| --- | --- |
| Cilium | `1.17.2` |
| containerd | `2.0.4` |
| containernetworking/plugins | `v1.6.2` |
| gVisor | latest stable |
| kubeadm | `v1.32.3` |
| kubelet | `v1.32.3` |
| runc | `v1.2.6` |

### Custom resource definitions \(CRDs\)

The following CRDs are installed.

| Name | Version |
| --- | --- |
| kubernetes-sigs/gateway-api | `v1.2.1` |

### Command-line utilities

The following command-line utilities are installed on all master nodes.

| Name | Version |
| --- | --- |
| Cilium CLI | `v0.18.3` |
| Helm | `v3.17.2` |
| Hubble CLI | `v1.17.2` |
| jq | system provided |
| kubectl | `v1.32.3` |
| kube-bench | `v0.10.4` |
| mkcert | `v1.4.4` |
| yq | `v4.45.1` |

## Quickstart

Clone the repository and make it your working directory.

### Ansible configuration

Sample Ansible configuration file `ansible/ansible.cfg`:

```ini
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

The following variables can be configured when running `ansible-playbook`.

| Name | Required | Default |
| --- | --- | --- |
| `pod_cidr` | - | `10.244.0.0/16` |
| `service_cidr` | - | `10.96.0.0/16` |

```bash
ANSIBLE_CONFIG="${PWD}/ansible/ansible.cfg" \
    ansible-playbook "${PWD}/ansible/playbook.yaml"
```

## License

[Apache 2.0](./LICENSE)
