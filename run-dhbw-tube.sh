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

# Create kubernetes environment with skaffold script
echo "Creating kubernetes environment with skaffold..."
skaffold run

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

# Install prometheus and grafana
echo "Installing prometheus and grafana..."
helm install prometheus prometheus-community/prometheus \
  --namespace dhbw-tube \
  -f k8s/prometheus/prometheus-values.yaml \
  --set server.global.scrape_interval="15s"
helm install grafana grafana/grafana \
  --namespace dhbw-tube \
  -f k8s/grafana/grafana-values.yaml

# Print the URL to access the application, prometheus and grafana
echo ""
echo "DHBW-Tube runs on: http://localhost/"
echo ""
echo "To access prometheus and grafana create a port-forward with the following commands:"
echo "kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube"
echo "kubectl port-forward svc/grafana 9999:80 -n dhbw-tube"
echo ""

# Start minikube tunnel
echo "Starting Minikube tunnel..."
minikube tunnel