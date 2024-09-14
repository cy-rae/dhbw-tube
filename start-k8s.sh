#!/bin/bash

# Start minikube if it is not already running
if ! minikube status &>/dev/null; then
  echo "Start minikube..."
  minikube start
else
  echo "Minikube is already running. Skip start..."
fi

# Delete existing namespace if it exists to ensure a clean environment
if kubectl get namespace dhbw-tube &>/dev/null; then
  echo "Deleting existing dhbw-tube namespace..."
  kubectl delete namespace dhbw-tube
  # Wait for the namespace to be completely deleted
  while kubectl get namespace dhbw-tube &>/dev/null; do
    echo "Waiting for dhbw-tube namespace to be deleted..."
    sleep 2
  done
fi

# Enable the ingress addon in Minikube
echo "Enabling Ingress addon in Minikube..."
minikube addons enable ingress

# Create docker images
eval $(minikube docker-env)
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
echo "DHBW-Tube runs on: http://localhost:80/"

# Tunnel minikube to localhost
minikube tunnel