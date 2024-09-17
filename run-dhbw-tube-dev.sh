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

# Check if prometheus is added to the helm repositories. If not add it.
if helm repo list | grep -q "prometheus-community"; then
  echo "Prometheus helm repository is already added..."
else
  echo "Adding Prometheus helm repository..."
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
fi

# Check if grafana is added to the helm repositories. If not add it.
if helm repo list | grep -q "grafana"; then
  echo "Grafana helm repository is already added..."
else
  echo "Adding Grafana helm repository..."
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update
fi

# Create kubernetes environment with skaffold script
echo "Creating kubernetes environment with skaffold..."
skaffold dev -f skaffold.yaml