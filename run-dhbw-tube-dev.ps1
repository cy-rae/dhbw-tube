# Start minikube if it is not already running
$minikubeStatus = minikube status --format='{{.Host}}'
if ($minikubeStatus -ne 'Running') {
    Write-Output "Start minikube..."
    minikube start
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

# Create Kubernetes environment with skaffold script
Write-Output "Creating Kubernetes environment with skaffold..."
skaffold run -f skaffold.yaml
