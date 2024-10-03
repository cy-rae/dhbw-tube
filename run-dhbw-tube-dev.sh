#!/bin/bash

# Start minikube if it is not already running
if ! minikube status &>/dev/null; then
  # Start minikube with 6GB of memory and 2 CPUs so streaming and uploading files up to 4gb is possible.
  echo "Start minikube..."
  minikube start --memory=20480 --cpus=8
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

# Apply vertical pod autoscalers (HPA is applied by default)
echo "Applying vertical autoscalers..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/vpa-release-1.0/vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/vpa-release-1.0/vertical-pod-autoscaler/deploy/vpa-rbac.yaml

# Create kubernetes environment with skaffold script
echo "Creating kubernetes environment with skaffold..."
skaffold dev