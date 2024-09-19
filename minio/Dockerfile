# Use basic MinIO image
FROM minio/minio:RELEASE.2024-09-13T20-26-02Z-cpuv1

# Add health check script
COPY check-health.sh /usr/local/bin/check-health.sh

# Make the script executable
RUN chmod +x /usr/local/bin/check-health.sh

# Start minio server
CMD ["minio", "server", "/data", "--console-address", ":9001"]
