# kubeadm-security-1m1w

Kubeadm cluster with 1 master, 1 worker and stringent security defaults

## Dependencies

Ansible should be installed.

With one of the supported managed infrastructure providers below, OpenTofu should be installed as well:

- Amazon Web Services \(AWS\)
- Microsoft Azure \(Azure\)
- Alibaba Cloud \(Aliyun\)

With self-provisioned infrastructure, ensure you have SSH access to 2 nodes with the following specifications:

- OS: Ubuntu 24.04 LTS \(Noble\)
- Architecture: `amd64`
- vCPU: at least 2
- Memory \(GiB\): at least 8
- Storage \(GiB\): at least 64
- Passwordless `sudo` should be enabled

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

### Provision the infrastructure

For the supported managed infrastructure providers above, you can provision the infrastructure automatically with OpenTofu; otherwise, you must manually provision the infrastructure.

Example:

```bash
export CLOUD_PROVIDER="aws" # or "azure", "aliyun"

# Set provider-specific OpenTofu variables here
# E.g. AWS: allow SSH access from 1.2.3.4/32 and 5.6.7.8/29
#export TF_VAR_trusted_cidr_blocks='["1.2.3.4/32","5.6.7.8/29"]'
# ...

tofu -chdir="opentofu/$CLOUD_PROVIDER/" init
tofu -chdir="opentofu/$CLOUD_PROVIDER/" plan
tofu -chdir="opentofu/$CLOUD_PROVIDER/" apply
```

#### OpenTofu variables for AWS

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `trusted_cidr_blocks` | `list(string)` | Y | - |
| `region` | `string` | - | `"ap-east-1"` |
| `vpc_cidr` | `string` | - | `"10.0.0.0/16"` |
| `subnet_cidr` | `string` | - | `"10.0.0.0/24"` |
| `ssh_public_key_path` | `string` | - | `"~/.ssh/id_ed25519.pub"` |
| `instance_type` | `string` | - | `"t3.large"` |
| `sys_volume_size` | `number` | - | `64` |
| `ssh_private_key_path` | `string` | - | `"~/.ssh/id_ed25519"` |

#### OpenTofu variables for Azure

TODO

#### OpenTofu variables for Aliyun

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `access_key` | `string` | Y | - |
| `secret_key` | `string` | Y | - |
| `trusted_cidr_block` | `string` | Y | - |
| `region` | `string` | - | `"cn-hongkong"` |
| `vpc_cidr` | `string` | - | `"10.0.0.0/16"` |
| `vswitch_cidr` | `string` | - | `"10.0.0.0/24"` |
| `ssh_public_key_path` | `string` | - | `"~/.ssh/id_ed25519.pub"` |
| `instance_type` | `string` | - | `"ecs.g8i.large"` |
| `system_disk_size` | `number` | - | `64` |
| `ssh_private_key_path` | `string` | - | `"~/.ssh/id_ed25519"` |

### Ansible configuration

The Ansible configuration file `ansible/ansible.cfg` is auto-generated with the supported managed infrastructure providers above; otherwise, you must provide your own.

Example:

```ini
[defaults]
inventory = ./hosts.yaml
remote_user = ubuntu
private_key_file = /path/to/your/id_ed25519
host_key_checking = False
```

### Ansible inventory

The Ansible inventory file `ansible/hosts.yaml` is auto-generated with the supported managed infrastructure providers above; otherwise, you must provide your own.

Example:

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

## Non-compliant CIS Kubernetes Benchmark v1.11 controls

The following CIS Kubernetes Benchmark v1.11 controls are non-compliant at the time of writing \(2025-04-06\). There are currently no plans to ensure compliance for the listed controls due to the reasons below.

### 4.3.1 Ensure that the kube-proxy metrics service is bound to localhost

Cilium kube-proxy replacement is enabled so this control is not applicable to our setup.

### 5.1.1 Ensure that the cluster-admin role is only used where required

Kubeadm 1.29 introduced a new group `kubeadm:cluster-admins` bound to the `cluster-admin` role and separated the revocable admin kubeconfig `/etc/kubernetes/admin.conf` from the irrevocable break-glass super-admin kubeconfig `/etc/kubernetes/super-admin.conf`. This is by design and addresses the security concern of leaking the latter to external actors.

See [Implementation details | Kubernetes](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/) for more details.

### 5.1.3 Minimize wildcard use in Roles and ClusterRoles

Some default Roles and ClusterRoles created by kubeadm contain wildcards by necessity and is required for proper cluster operation.

### 5.1.6 Ensure that Service Account Tokens are only mounted where necessary

Many Cilium pods use a non-default service account with least-privilege RBAC permissions for managing Cilium custom resources vital to cluster networking. They interact with the Kubernetes API server regularly using the mounted service account token for authentication.

## License

[Apache 2.0](./LICENSE)
