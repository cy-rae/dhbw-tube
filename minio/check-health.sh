#!/bin/sh

# Configure MinIO client with the alias 'myminio'
mc alias set myminio http://localhost:9000 minioadmin minioadmin

# Check health of MinIO server
mc admin info myminio
