#!/bin/sh

# Check if curl is installed
if command -v curl &> /dev/null
then
    # If curl is installed, check MinIO health via curl
    curl -f http://localhost:9000/minio/health/live
    if [ $? -ne 0 ]; then
        echo "MinIO health check with curl failed."
        exit 1
    fi
    exit 0
fi

# Check if mc (MinIO client) is installed
if command -v mc &> /dev/null
then
    # If mc is installed, configure and check MinIO health via mc
    mc alias set myminio http://localhost:9000 minioadmin minioadmin
    mc admin info myminio
    if [ $? -ne 0 ]; then
        echo "MinIO health check with mc failed."
        exit 1
    fi
    exit 0
fi

# If neither curl nor mc is installed, output a message
echo "Neither curl nor Minio-Client are installed on this Minio-Image"
exit 1
