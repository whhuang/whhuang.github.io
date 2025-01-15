for file in *.{heic,HEIC,png,PNG,jpg,JPG,jpeg,JPEG}; do
    [ -e "$file" ] || continue
    base_name="${file%.*}"
    magick "$file" -resize 1000x "${base_name}.webp"
    rm "$file"
done
