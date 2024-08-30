#!/bin/sh

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl is not installed. Installing curl..."
    # Install curl
    apt-get update && apt-get install -y curl
    if [ $? -ne 0 ]; then
        echo "Failed to install curl. Exiting."
        exit 1
    fi
fi

# Check if MinIO client is installed
if ! command -v mc &> /dev/null
then
    echo "MinIO client is not installed. Installing MinIO client..."
    # Download the MinIO client binary
    curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
    chmod +x mc
    mv mc /usr/local/bin/mc
fi

# Configure MinIO client with the alias 'myminio'
mc alias set myminio http://localhost:9000 minioadmin minioadmin

# Check health of MinIO server
mc admin info myminio
