for file in *.HEIC; do
    [ -e "$file" ] || continue
    base_name="${file%.*}"
    magick "$file" -resize 1000x "${base_name}.webp"
    rm "$file"
done
