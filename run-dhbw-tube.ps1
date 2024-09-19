# Start minikube if it is not already running
$minikubeStatus = minikube status --format='{{.Host}}'
if ($minikubeStatus -ne 'Running') {
    # Start minikube with 6GB of memory and 2 CPUs so streaming and uploading files up to 4gb is possible.
    Write-Output "Start minikube..."
    minikube start --memory=6100 --cpus=2
} else {
    Write-Output "Minikube is already running. Skip start..."
}

# Delete existing namespace if it exists to ensure a clean environment
$namespaceExists = kubectl get namespace dhbw-tube -o jsonpath='{.metadata.name}' 2>$null
if ($namespaceExists) {
    Write-Output "Deleting existing dhbw-tube namespace..."
    kubectl delete namespace dhbw-tube
    # Wait for the namespace to be completely deleted
    while (kubectl get namespace dhbw-tube -o jsonpath='{.metadata.name}' 2>$null) {
        Write-Output "Waiting for dhbw-tube namespace to be deleted..."
        Start-Sleep -Seconds 2
    }
}

# Create Kubernetes environment with skaffold script
Write-Output "Creating Kubernetes environment with skaffold..."
skaffold run

# Check if prometheus is added to the helm repositories. If not add it.
$prometheusRepo = helm repo list | Select-String -Pattern "prometheus-community"
if ($prometheusRepo) {
    Write-Output "Prometheus helm repository is already added..."
} else {
    Write-Output "Adding Prometheus helm repository..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
}

# Check if grafana is added to the helm repositories. If not add it.
$grafanaRepo = helm repo list | Select-String -Pattern "grafana"
if ($grafanaRepo) {
    Write-Output "Grafana helm repository is already added..."
} else {
    Write-Output "Adding Grafana helm repository..."
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
}

# Install prometheus and grafana
Write-Output "Installing Prometheus and Grafana..."
helm install prometheus prometheus-community/prometheus `
  --namespace dhbw-tube `
  -f k8s/prometheus/prometheus-values.yaml `
  --set server.global.scrape_interval="15s"
helm install grafana grafana/grafana `
  --namespace dhbw-tube `
  -f k8s/grafana/grafana-values.yaml

# Print the URL to access the application, prometheus, and grafana
Write-Output ""
Write-Output "DHBW-Tube runs on: http://localhost/"
Write-Output ""
Write-Output "To access Prometheus and Grafana, create a port-forward with the following commands:"
Write-Output "kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube"
Write-Output "kubectl port-forward svc/grafana 9999:80 -n dhbw-tube"
Write-Output ""

# Start minikube tunnel
Write-Output "Starting Minikube tunnel..."
minikube tunnel
