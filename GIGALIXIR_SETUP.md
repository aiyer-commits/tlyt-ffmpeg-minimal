# Gigalixir Setup Instructions

## Method 1: Using the Buildpack

Add the buildpack to your `.buildpacks` file in your Phoenix project:

```
https://github.com/HashNuke/heroku-buildpack-elixir
https://github.com/gjaldon/heroku-buildpack-phoenix-static
https://github.com/aiyer-commits/tlyt-ffmpeg-minimal#gigalixir-buildpack
```

## Method 2: Download in Release Script

Add to your `rel/overlays/bin/post_compile` script:

```bash
#!/bin/bash
echo "Downloading minimal FFmpeg binary..."
curl -L -o $HOME/bin/ffmpeg https://github.com/aiyer-commits/tlyt-ffmpeg-minimal/releases/latest/download/ffmpeg-minimal
chmod +x $HOME/bin/ffmpeg
```

## Method 3: Include in Docker Image

If using Docker deployment, add to your Dockerfile:

```dockerfile
# Download minimal FFmpeg
RUN curl -L -o /usr/local/bin/ffmpeg \
    https://github.com/aiyer-commits/tlyt-ffmpeg-minimal/releases/latest/download/ffmpeg-minimal && \
    chmod +x /usr/local/bin/ffmpeg
```

## Configuration

Set the FFmpeg path in your config:

```elixir
# config/prod.exs
config :tlyt_phoenix, :ffmpeg_path, "/app/bin/ffmpeg"

# Or use environment variable
config :tlyt_phoenix, :ffmpeg_path, System.get_env("FFMPEG_PATH") || "/app/bin/ffmpeg"
```

## Memory Optimization

The minimal binary uses less memory than full FFmpeg:
- No audio decoding overhead
- Minimal codec support
- Optimized for single frame extraction

For very large videos, consider:
1. Using `-ss` flag for fast seeking
2. Limiting resolution with scale filter
3. Processing one frame at a time