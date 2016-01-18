#!/usr/bin/env bash

for movie in *mov;do
  echo "Converting $movie to jpeg sequence..."
  mov=${movie/\.mov/}
  mkdir -vp $mov/{images,audio}
  ffmpeg -i $movie -an -f image2 $mov/images/$mov.%04d.jpg
  ffmpeg -i $movie -vn $mov/audio/$mov.aiff
  echo "Done."
done
