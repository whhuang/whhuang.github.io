for file in *.{mov,MOV}; do
    [ -e "$file" ] || continue
    base_name="${file%.*}"
    ffmpeg -i "$file" -c:v vp9 -crf 30 -b:v 0 -c:a libopus -b:a 96k "${base_name}.webm"
    rm "$file"
done