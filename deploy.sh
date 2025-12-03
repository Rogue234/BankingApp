#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage
usage() {
    echo "Usage: $0 -i <image_name> -t <tag> -p <host_port:container_port> -v <host_volume:container_volume>"
    echo "Example: $0 -i rogue234/banking-app -t latest -p 8080:8080 -v /data:/app/data"
    exit 1
}

# Parse command-line arguments
while getopts ":i:t:p:v:" opt; do
    case $opt in
        i) IMAGE_NAME="$OPTARG" ;;
        t) TAG="$OPTARG" ;;
        p) PORT_MAPPING="$OPTARG" ;;
        v) VOLUME_MAPPING="$OPTARG" ;;
        *) usage ;;
    esac
done

# Check if all required arguments are provided
if [ -z "$IMAGE_NAME" ] || [ -z "$TAG" ] || [ -z "$PORT_MAPPING" ]; then
    usage
fi

# Pull the Docker image
echo "Pulling Docker image: $IMAGE_NAME:$TAG..."
docker pull "$IMAGE_NAME:$TAG"

# Stop and remove any existing container with the same name
CONTAINER_NAME=$(echo "$IMAGE_NAME" | tr '/' '_') # Replace '/' with '_' for container name
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME..."
    docker stop "$CONTAINER_NAME" || true
    docker rm "$CONTAINER_NAME" || true
fi

# Run the Docker container
echo "Running Docker container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -p "$PORT_MAPPING" \
    ${VOLUME_MAPPING:+-v "$VOLUME_MAPPING"} \
    "$IMAGE_NAME:$TAG"

echo "Deployment completed successfully!"
echo "Container Name: $CONTAINER_NAME"
echo "Image: $IMAGE_NAME:$TAG"
echo "Port Mapping: $PORT_MAPPING"
if [ -n "$VOLUME_MAPPING" ]; then
    echo "Volume Mapping: $VOLUME_MAPPING"
fi
