resource "kind_cluster" "this" {
  name           = var.cluster_name
  node_image     = var.node_image
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<-YAML
        kind: InitConfiguration
        nodeRegistration:
            kubeletExtraArgs:
                node-labels: "ingress-ready=true"
        YAML
      ]

      extra_port_mappings {
        container_port = var.gateway_http_node_port
        host_port      = var.http_host_port
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = var.gateway_https_node_port
        host_port      = var.https_host_port
        protocol       = "TCP"
      }
    }

    dynamic "node" {
      for_each = range(var.workers)
      content {
        role = "worker"
      }
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content         = kind_cluster.this.kubeconfig
  filename        = "${path.module}/kubeconfig"
  file_permission = "0600"
}