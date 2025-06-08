#!/bin/bash
set -e

echo "Building minimal FFmpeg binary..."

# Build the Docker image
docker build -t ffmpeg-minimal-builder .

# Extract the binary from the image
echo "Extracting binary from Docker image..."
docker create --name temp-ffmpeg ffmpeg-minimal-builder
docker cp temp-ffmpeg:/ffmpeg ./ffmpeg-minimal
docker rm temp-ffmpeg

# Get file size
SIZE=$(ls -lh ffmpeg-minimal | awk '{print $5}')
echo "Binary size: $SIZE"

# Test the binary
echo "Testing binary..."
./ffmpeg-minimal -version || echo "Note: Binary might need libraries from the host system"

echo "Build complete!"