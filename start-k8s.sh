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

skaffold dev

# Print the URL to access the application
echo "DHBW-Tube runs on: http://localhost/"

# Check if a Minikube tunnel is already running. If not start it.
if pgrep -f "minikube tunnel" &>/dev/null; then
  echo "Minikube tunnel is already running..."
else
  echo "Starting Minikube tunnel..."
  minikube tunnel
fi