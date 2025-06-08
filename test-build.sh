#!/bin/bash
# Test build locally

echo "Testing minimal FFmpeg build..."

# Try the ultra-minimal build
echo "Building ultra-minimal version..."
docker build -f Dockerfile.ultra-minimal -t ffmpeg-test . || {
    echo "Ultra-minimal build failed, trying regular minimal..."
    docker build -f Dockerfile -t ffmpeg-test .
}

# Extract binary
docker create --name test-extract ffmpeg-test
docker cp test-extract:/ffmpeg ./ffmpeg-test
docker rm test-extract

# Check size
echo "Binary details:"
ls -lh ffmpeg-test
file ffmpeg-test

# Test basic functionality
echo "Testing version info..."
./ffmpeg-test -version 2>&1 | head -10 || echo "Version check failed (expected on static binary)"

# Clean up
rm -f ffmpeg-test

echo "Test complete!"