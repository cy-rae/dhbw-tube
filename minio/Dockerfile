# Use basic MinIO image
FROM minio/minio

# Add health check script
COPY check-health.sh /usr/local/bin/check-health.sh

# Make the script executable
RUN chmod +x /usr/local/bin/check-health.sh

# Start minio server
CMD ["minio", "server", "/data", "--console-address", ":9001"]
