#!/bin/bash

# Create docker images
docker build -t dhbw-tube-frontend ./dhbw-tube-frontend
docker build -t dhbw-tube-stream ./dhbw-tube-stream
docker build -t dhbw-tube-upload ./dhbw-tube-upload
docker build -t minio ./minio

# Start minikube if it is not already running
if ! minikube status &>/dev/null; then
  echo "Start minikube..."
  minikube start
else
  echo "Minikube is already running. Skip start..."
fi

# Enable the ingress addon in Minikube
echo "Enabling Ingress addon in Minikube..."
minikube addons enable ingress

# Delete existing namespace if it exists
if kubectl get namespace dhbw-tube &>/dev/null; then
  echo "Deleting existing dhbw-tube namespace..."
  kubectl delete namespace dhbw-tube
  # Wait for the namespace to be completely deleted
  while kubectl get namespace dhbw-tube &>/dev/null; do
    echo "Waiting for dhbw-tube namespace to be deleted..."
    sleep 2
  done
fi

# Create namespace for dhbw-tube cluster
kubectl create namespace dhbw-tube

# Apply config maps
kubectl apply -f kubernetes/postgres/postgres-config-map.yaml
kubectl apply -f kubernetes/minio/minio-config-map.yaml
kubectl apply -f kubernetes/upload/upload-config-map.yaml
kubectl apply -f kubernetes/stream/stream-config-map.yaml
kubectl apply -f kubernetes/frontend/frontend-config-map.yaml

# Apply persistent volume claims
kubectl apply -f kubernetes/postgres/postgres-pvc.yaml
kubectl apply -f kubernetes/minio/minio-pvc.yaml

# Apply deployments
kubectl apply -f kubernetes/postgres/postgres-deployment.yaml
kubectl apply -f kubernetes/minio/minio-deployment.yaml
kubectl apply -f kubernetes/upload/upload-deployment.yaml
kubectl apply -f kubernetes/stream/stream-deployment.yaml
kubectl apply -f kubernetes/frontend/frontend-deployment.yaml

# Apply services
kubectl apply -f kubernetes/postgres/postgres-service.yaml
kubectl apply -f kubernetes/minio/minio-service.yaml
kubectl apply -f kubernetes/upload/upload-service.yaml
kubectl apply -f kubernetes/stream/stream-service.yaml
kubectl apply -f kubernetes/frontend/frontend-service.yaml

# Apply Ingress resource
kubectl apply -f kubernetes/ingress.yaml

# Retrieve the minikube IP
echo "Minikube IP:"
minikube ip
