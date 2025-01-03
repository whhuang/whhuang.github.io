for file in *; do
    [ -e "$file" ] || continue
    base_name="${file%.*}"
    ffmpeg -i "$file" -vcodec libx264 -crf 28 -preset fast -acodec aac -b:a 96k "${base_name}.mp4"
done