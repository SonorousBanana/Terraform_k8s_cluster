variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
  default     = "my-cluster"
}

variable "node_image" {
  description = "kindest/node image = Kubernetes version. See https://github.com/kubernetes-sigs/kind/releases"
  type        = string
  default     = "kindest/node:v1.34.0"
}

variable "workers" {
  description = "Number of worker nodes."
  type        = number
  default     = 2

  validation {
    condition     = var.workers >= 0 && var.workers <= 5
    error_message = "workers must be between 0 and 5."
  }
}

variable "http_host_port" {
  description = "Port on your machine that forwards to the Gateway HTTP listener."
  type        = number
  default     = 80
}

variable "https_host_port" {
  description = "Port on your machine that forwards to the Gateway HTTPS listener."
  type        = number
  default     = 443
}

variable "gateway_http_node_port" {
  description = "NodePort used by Envoy for HTTP (must match platform/profiles/kind.tfvars)."
  type        = number
  default     = 30080
}

variable "gateway_https_node_port" {
  description = "NodePort used by Envoy for HTTPS (must match platform/profiles/kind.tfvars)."
  type        = number
  default     = 30443
}
