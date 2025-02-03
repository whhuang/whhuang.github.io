#!/bin/bash

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file
export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)

# Get the current directory name
DIR_NAME="$(basename "$PWD")"

# Run compression scripts
bash "$SCRIPT_DIR/compress_images.sh"
bash "$SCRIPT_DIR/compress_videos.sh"

shopt -s nullglob

# Upload images
for file in *.webp; do
    curl -X PUT "https://whitneyhuang-website.4db0164421cbdb51b1a07454aa10592a.r2.cloudflarestorage.com/images/$DIR_NAME/$file" \
        -H "Authorization: Bearer $CLOUDFLARE_R2_TOKEN" \
        -H "Content-Type: image/webp" \
        --data-binary "@$file"
done

# Upload videos
for file in *.webm; do
    curl -X PUT "https://whitneyhuang-website.4db0164421cbdb51b1a07454aa10592a.r2.cloudflarestorage.com/videos/$DIR_NAME/$file" \
        -H "Authorization: Bearer $CLOUDFLARE_R2_TOKEN" \
        -H "Content-Type: video/webm" \
        --data-binary "@$file"
done
