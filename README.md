# Minimal FFmpeg for Frame Extraction

This repository contains a minimal FFmpeg binary optimized specifically for extracting frames from videos, particularly from YouTube URLs.

## Features

This minimal build includes only:
- HTTP/HTTPS protocol support (for streaming from URLs)
- H264 and VP9 video decoders (covers most YouTube videos)
- MJPEG encoder (for JPEG frame output)
- Scale filter (for creating thumbnails)
- No audio support
- No unnecessary codecs or features

## Binary Size

The goal is to achieve a binary size under 10MB through:
- Static linking
- Link-time optimization (LTO)
- Aggressive stripping
- UPX compression (optional)
- Minimal feature set

## Usage

```bash
# Extract a single frame at 10 seconds
./ffmpeg-minimal -ss 10 -i "https://youtube.com/watch?v=..." -frames:v 1 -f image2 frame.jpg

# Extract frame and scale to thumbnail
./ffmpeg-minimal -ss 10 -i "https://youtube.com/watch?v=..." -vf scale=320:180 -frames:v 1 thumbnail.jpg
```

## Building

```bash
# Build with Docker
./build.sh

# Or use the ultra-minimal version
docker build -f Dockerfile.ultra-minimal -t ffmpeg-ultra-minimal .
```

## Gigalixir Buildpack

See `gigalixir-buildpack/` directory for the buildpack that downloads this binary during deployment.

## License

FFmpeg is licensed under the GPL. This minimal build maintains the same license.