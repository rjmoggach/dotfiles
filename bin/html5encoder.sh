#!/usr/bin/env bash
#
# HTML 5 Video Bash Script
#
# https://gist.github.com/yellowled/1439610


# # webm
# ffmpeg -i IN -f webm -vcodec libvpx -acodec libvorbis -ab 128000 -crf 22 -s 640x360 OUT.webm
#
# # mp4
# ffmpeg -i IN -acodec aac -strict experimental -ac 2 -ab 128k -vcodec libx264 -vpre slow -f mp4 -crf 22 -s 640x360 OUT.mp4
#
# # ogg (if you want to support older Firefox)
# ffmpeg2theora IN -o OUT.ogv -x 640 -y 360 --videoquality 5 --audioquality 0  --frontend
#



SRC_VIDEO=$1

DEST_VIDEO=$(echo $1 | sed 's/^\(.*\)\.[a-zA-Z0-9]*$/\1/')

BASENAME=$(basename $DEST_VIDEO)
DIRNAME=$(dirname $DEST_VIDEO)
PARENT_DIR=$(dirname $DIRNAME)

DEST=$PARENT_DIR/web_video

if [ -d "$DEST" ]; then
    DEST_VIDEO=$DEST/$BASENAME
else
    DEST_VIDEO=$DEST_VIDEO
fi

# mp4
ffmpeg -i ${SRC_VIDEO} -f mp4 -hide_banner -y \
    -c:v libx264 -preset slow -b:v 1536000 -qmin 0 -qmax 32 \
    -c:a aac -q:a 5 -ac 2 -ab 128000 \
    -strict experimental -movflags faststart \
    -vf scale=960:-1 "${DEST_VIDEO}-960.mp4"

ffmpeg -i ${SRC_VIDEO} -f mp4 -hide_banner -y \
    -c:v libx264 -preset slow -b:v 1024000 -qmin 0 -qmax 32 \
    -c:a aac -q:a 5 -ac 2 -ab 128000 \
    -strict experimental -movflags faststart \
    -vf scale=640:-1 "${DEST_VIDEO}-640.mp4"

ffmpeg -i ${SRC_VIDEO} -f mp4 -hide_banner -y \
    -c:v libx264 -preset slow -b:v 819200 -qmin 0 -qmax 32 \
    -c:a aac -q:a 4 -ac 2 -ab 128000 \
    -strict experimental -movflags faststart \
    -vf scale=480:-1 "${DEST_VIDEO}-480.mp4"



# OGG (if you want to support older Firefox)
# -b 819200specifies the bitrate ( 800 kbps , 800 x 1024 = 819200)
ffmpeg -i ${SRC_VIDEO} -f ogg -hide_banner -y \
    -c:v libtheora -preset slow -b:v 819200 -qmin 0 -qmax 32 \
    -c:a libvorbis -q:a 5 -ac 2 -ab 128000 \
    -strict experimental \
    -vf scale=640:-1 "${DEST_VIDEO}-640.ogv"

# ffmpeg2theora ${SRC_VIDEO} -o "${DEST_VIDEO}-640.ogv" --max_size 640 --videoquality 5 --audioquality 0  --frontend


# WEBM
# -b 614400 specifies the bitrate ( 600 kbps video,600 x 1024 = 614400)
ffmpeg -i ${SRC_VIDEO} -f webm -hide_banner -y \
    -c:v libvpx -preset slow -b:v 614400 -qmin 0 -qmax 25 \
    -c:a libvorbis -q:a 5 -ac 2 -ab 128000 \
    -vf scale=640:-1 "${DEST_VIDEO}-640.webm"






# ffmpeg -i $SRC_VIDEO -c:v libvpx -pass 1 -an -f rawvideo -y /dev/null  # Generates ffmpeg2pass-0.log
# ffmpeg -i $SRC_VIDEO -c:v libvpx -pass 2 -f webm -b:v 400K -crf 10 -an -y ${DEST_VIDEO}.webm

# screen shot at 10s
# ffmpeg -i %1 -ss 00:10 -vframes 1 -r 1 -s 640x360 -f image2 %1.jpg





# <source src="http://moggach.com/media/video/hyundai-magic-wand/hyundai-magic_wand-60-960x540.mp4"  type="video/mp4" />
# <source src="http://moggach.com/media/video/hyundai-magic-wand/hyundai-magic_wand-60-640x360.mp4"  type="video/mp4" />
# <source src="http://moggach.com/media/video/hyundai-magic-wand/hyundai-magic_wand-60-640x360.ogv"  type="video/ogg" />
# <source src="http://moggach.com/media/video/hyundai-magic-wand/hyundai-magic_wand-60-640x360.webm"  type="video/webm" />
# <source src="http://moggach.com/media/video/hyundai-magic-wand/hyundai-magic_wand-60-480x270.mp4"  type="video/mp4" />
# brew reinstall ffmpeg --with-dcadec --with-faac --with-fdk-aac --with-ffplay \
# --with-fontconfig --with-freetype --with-libass --with-libquvi --with-libsoxr \
# --with-libvorbis --with-libvpx --with-openjpeg --with-openssl --with-opus \
# --with-schroedinger --with-theora --with-tools --with-webp --with-x265
