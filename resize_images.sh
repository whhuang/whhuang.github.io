for file in *.png; do
  ffmpeg -i "$file" -vf scale=1000:-1 "resized-$file"
  mv "resized-$file" "$file"
  rm "resized-$file"
done