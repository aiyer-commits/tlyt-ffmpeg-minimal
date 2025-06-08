# Build minimal FFmpeg for frame extraction only
FROM alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    git \
    nasm \
    yasm \
    pkgconfig \
    zlib-dev \
    openssl-dev \
    linux-headers

# Set build environment
ENV CFLAGS="-O3 -ffunction-sections -fdata-sections -fno-semantic-interposition -flto=auto" \
    CXXFLAGS="-O3 -ffunction-sections -fdata-sections -fno-semantic-interposition -flto=auto" \
    LDFLAGS="-Wl,--gc-sections -Wl,--strip-all -flto=auto -static"

WORKDIR /build

# Build FFmpeg with minimal configuration
RUN git clone --depth 1 --branch n6.1.1 https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    ./configure \
        --prefix=/usr/local \
        --disable-everything \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-doc \
        --disable-htmlpages \
        --disable-manpages \
        --disable-podpages \
        --disable-txtpages \
        --disable-avdevice \
        --disable-swresample \
        --disable-swscale \
        --disable-postproc \
        --disable-avfilter \
        --disable-pthreads \
        --disable-w32threads \
        --disable-os2threads \
        --disable-network \
        --disable-debug \
        --disable-runtime-cpudetect \
        --disable-pixelutils \
        --enable-small \
        --enable-lto \
        --enable-static \
        --disable-shared \
        --enable-gpl \
        --enable-protocol=file \
        --enable-protocol=http \
        --enable-protocol=https \
        --enable-protocol=tcp \
        --enable-protocol=tls \
        --enable-openssl \
        --enable-decoder=h264 \
        --enable-decoder=vp9 \
        --enable-decoder=vp8 \
        --enable-encoder=mjpeg \
        --enable-demuxer=mov \
        --enable-demuxer=mp4 \
        --enable-demuxer=matroska \
        --enable-demuxer=webm \
        --enable-demuxer=flv \
        --enable-muxer=image2 \
        --enable-muxer=mjpeg \
        --enable-filter=scale \
        --enable-swscale \
        --extra-cflags="$CFLAGS" \
        --extra-cxxflags="$CXXFLAGS" \
        --extra-ldflags="$LDFLAGS" && \
    make -j$(nproc) && \
    make install && \
    strip -s /usr/local/bin/ffmpeg

# Final stage - just the binary
FROM scratch
COPY --from=builder /usr/local/bin/ffmpeg /ffmpeg
ENTRYPOINT ["/ffmpeg"]