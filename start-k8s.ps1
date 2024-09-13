# Start minikube if it is not already running
$minikubeStatus = minikube status
if ($minikubeStatus -like "*Running*") {
    Write-Output "Minikube is already running. Skip start..."
} else {
    Write-Output "Start minikube..."
    minikube start
}

# Delete existing namespace if it exists
if (kubectl get namespace dhbw-tube -ErrorAction SilentlyContinue) {
    Write-Output "Deleting existing dhbw-tube namespace..."
    kubectl delete namespace dhbw-tube
    # Wait for the namespace to be completely deleted
    while (kubectl get namespace dhbw-tube -ErrorAction SilentlyContinue) {
        Write-Output "Waiting for dhbw-tube namespace to be deleted..."
        Start-Sleep -Seconds 2
    }
}

# Enable the ingress addon in Minikube
Write-Output "Enabling Ingress addon in Minikube..."
minikube addons enable ingress

# Create docker images
& minikube -p minikube docker-env | Invoke-Expression
docker build -t dhbw-tube-frontend ./dhbw-tube-frontend
docker build -t dhbw-tube-stream ./dhbw-tube-stream
docker build -t dhbw-tube-upload ./dhbw-tube-upload
docker build -t minio ./minio

# Create namespace for dhbw-tube cluster
kubectl create namespace dhbw-tube

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
Write-Output "Minikube IP:"
minikube ip