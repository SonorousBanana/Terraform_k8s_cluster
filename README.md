# Local Kubernetes Cluster with Terraform and kind

This repository creates a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/) and Terraform. It is intended for learning and testing; it does not create a cluster with a cloud provider.

> **What is included:** instructions for creating and deleting the cluster. The repository does not currently include ready-to-use application manifests or Helm charts. An optional example below shows how to run a test NGINX app.

## Prerequisites

On Windows, open **PowerShell** and install:

1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** with the Docker Engine running. Start Docker Desktop before continuing.
2. **[Terraform CLI 1.6 or later](https://developer.hashicorp.com/terraform/install)**.
3. **[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)**.
4. **[Git](https://git-scm.com/download/win)**, to download the repository.

Check that the tools are available:

```powershell
docker version
terraform version
kubectl version --client
git --version
```

The `docker version` command should show server information as well. If it reports a connection error, start Docker Desktop and try again.

## Create the cluster

1. Download the repository and change into its directory:

   ```powershell
   git clone https://github.com/SonorousBanana/Terraform_k8s_cluster.git
   cd Terraform_k8s_cluster
   ```

2. Copy the example configuration file:

   ```powershell
   Copy-Item cluster\terraform.tfvars.example cluster\terraform.tfvars
   ```

   Optionally, edit `cluster/terraform.tfvars` to change the cluster name, number of worker nodes, or ports. The default ports `80` and `443` must be available on your computer. If they are already in use, for example, change them to `8080` and `8443`.

3. Initialize and check the Terraform configuration:

   ```powershell
   terraform -chdir=cluster init
   terraform -chdir=cluster validate
   terraform -chdir=cluster plan
   ```

   The `plan` command shows what Terraform intends to create without making changes.

4. Create the cluster:

   ```powershell
   terraform -chdir=cluster apply
   ```

   Review the plan and type `yes` when Terraform asks for confirmation. Cluster creation may take a few minutes, especially the first time Kubernetes node images are downloaded.

5. Configure `kubectl` to use the cluster and check the nodes:

   ```powershell
   $env:KUBECONFIG = (terraform -chdir=cluster output -raw kubeconfig_path)
   kubectl get nodes
   ```

   In PowerShell, this environment variable only applies to the current window. If you open a new PowerShell window, run the `$env:KUBECONFIG = ...` command again.

## Optional: try NGINX

After creating the cluster and configuring `KUBECONFIG`, you can start a simple test app:

```powershell
kubectl create deployment hello-web --image=nginx:stable-alpine
kubectl rollout status deployment/hello-web
kubectl expose deployment hello-web --port=80 --type=ClusterIP
kubectl port-forward service/hello-web 8080:80
```

Leave the last command running and open <http://localhost:8080> in your browser. To stop port forwarding, press `Ctrl+C`.

NGINX is only a test app: it is not created by Terraform and will not persist after deleting the cluster. You can remove it before deleting the cluster:

```powershell
kubectl delete service/hello-web deployment/hello-web
```

## Useful commands

Show Terraform outputs:

```powershell
terraform -chdir=cluster output
```

List pods and services in the cluster:

```powershell
kubectl get pods --all-namespaces
kubectl get services --all-namespaces
```

## Delete the cluster

The following command deletes the cluster and everything in it. If you created the test NGINX app, delete it first using the commands in the previous section.

```powershell
terraform -chdir=cluster destroy
```

Type `yes` to confirm. This command does not uninstall Docker Desktop or Terraform.

## Troubleshooting

- **Docker is unavailable:** start Docker Desktop and wait for it to finish starting.
- **Port 80 or 443 is already in use:** change `http_host_port` or `https_host_port` in `cluster/terraform.tfvars`, then run `terraform -chdir=cluster apply` again.
- **`kubectl` cannot find the cluster:** set `$env:KUBECONFIG` again as described above, in the same PowerShell window where you run `kubectl`.
- **You changed settings and want to start over:** run `terraform -chdir=cluster destroy`, then run `terraform -chdir=cluster apply` again.

## Security

Terraform creates the kubeconfig file at `cluster/kubeconfig`. It contains credentials for accessing the cluster, so do not share it or commit it to Git. The same applies to Terraform state files (`*.tfstate`).
