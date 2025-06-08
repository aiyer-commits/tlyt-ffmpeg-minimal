#!/bin/bash
# Download the latest FFmpeg minimal binary

REPO="aiyer-commits/tlyt-ffmpeg-minimal"
echo "Fetching latest release info..."

LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Error: Could not determine latest release"
    exit 1
fi

echo "Latest release: $LATEST_RELEASE"
echo "Downloading FFmpeg minimal..."

curl -L -o ffmpeg-minimal https://github.com/$REPO/releases/download/$LATEST_RELEASE/ffmpeg-minimal
chmod +x ffmpeg-minimal

echo "Download complete!"
ls -lh ffmpeg-minimal