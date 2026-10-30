output "kubeconfig_path" {
  description = "Use with: export KUBECONFIG=<this path>"
  value       = local_sensitive_file.kubeconfig.filename
}

output "cluster_profile" {
  description = "Tells the platform stack how to expose Envoy."
  value       = "kind"
}

output "ingress_ip" {
  description = "Where the Gateway is reachable (via the docker port mapping)."
  value       = "127.0.0.1"
}

output "endpoint" {
  description = "The API server endpoint for the kind cluster."
  value       = kind_cluster.this.endpoint
}

output "public_https_port" {
  description = "Port to use in browser URLs."
  value       = var.https_host_port
}

output "public_http_port" {
  description = "Port to use in browser URLs."
  value       = var.http_host_port
}

output "gateway_http_node_port" {
  description = "NodePort used by Envoy for HTTP (must match platform/profiles/kind.tfvars)."
  value       = var.gateway_http_node_port
}

output "gateway_https_node_port" {
  description = "NodePort used by Envoy for HTTPS (must match platform/profiles/kind.tfvars)."
  value       = var.gateway_https_node_port
}

output "workers" {
  description = "Number of worker nodes."
  value       = var.workers
}

output "node_image" {
  description = "kindest/node image = Kubernetes version. See https://github.com/kubernetes-sigs/kind/releases"
  value       = var.node_image
}