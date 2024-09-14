# Check if Minikube is running
$minikubeStatus = minikube status --format='{{.Host}}' 2>$null
if ($minikubeStatus -ne "Running") {
    Write-Host "Starting Minikube..."
    minikube start
} else {
    Write-Host "Minikube is already running. Skipping start..."
}

# Delete existing namespace if it exists to ensure a clean environment
$namespaceExists = kubectl get namespace dhbw-tube 2>$null
if ($namespaceExists) {
    Write-Host "Deleting existing dhbw-tube namespace..."
    kubectl delete namespace dhbw-tube

    # Wait for the namespace to be completely deleted
    do {
        Write-Host "Waiting for dhbw-tube namespace to be deleted..."
        Start-Sleep -Seconds 2
        $namespaceExists = kubectl get namespace dhbw-tube 2>$null
    } while ($namespaceExists)
}

# Enable the ingress addon in Minikube
Write-Host "Enabling Ingress addon in Minikube..."
minikube addons enable ingress

# Create docker images
& minikube docker-env | Invoke-Expression
docker build -t dhbw-tube-frontend ./dhbw-tube-frontend
docker build -t dhbw-tube-stream ./dhbw-tube-stream
docker build -t dhbw-tube-upload ./dhbw-tube-upload
docker build -t minio ./minio

# Create namespace to isolate dhbw-tube application
kubectl apply -f k8s/namespace.yaml

# Apply config maps
kubectl apply -f k8s/postgres/postgres-config-map.yaml
kubectl apply -f k8s/minio/minio-config-map.yaml
kubectl apply -f k8s/upload/upload-config-map.yaml
kubectl apply -f k8s/stream/stream-config-map.yaml
kubectl apply -f k8s/frontend/frontend-config-map.yaml

# Apply persistent volume claims
kubectl apply -f k8s/postgres/postgres-pvc.yaml
kubectl apply -f k8s/minio/minio-pvc.yaml

# Apply deployments
kubectl apply -f k8s/postgres/postgres-deployment.yaml
kubectl apply -f k8s/minio/minio-deployment.yaml
kubectl apply -f k8s/upload/upload-deployment.yaml
kubectl apply -f k8s/stream/stream-deployment.yaml
kubectl apply -f k8s/frontend/frontend-deployment.yaml

# Apply services
kubectl apply -f k8s/postgres/postgres-service.yaml
kubectl apply -f k8s/minio/minio-service.yaml
kubectl apply -f k8s/upload/upload-service.yaml
kubectl apply -f k8s/stream/stream-service.yaml
kubectl apply -f k8s/frontend/frontend-service.yaml

# Apply Ingress resource
kubectl apply -f k8s/ingress.yaml

# Retrieve the minikube IP
Write-Host "DHBW-Tube runs on: http://localhost:80/"

# Tunnel minikube to localhost
minikube tunnel
