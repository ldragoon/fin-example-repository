# http://keycorner.org/pub/text/doc/ffmpeg-tutorial.htm
# https://www.ostechnix.com/20-ffmpeg-commands-beginners/
# https://ffmpeg.org/ffmpeg-formats.html

#! /bin/bash

# ffmpeg -i mb_v_mp4/yose-ynn24-monarchsandmilkweed_1280x720.mp4 -f hls -hls_list_size 1000000 -hls_time 60 mpd/monarch_butterfly.mpd
# ffmpeg -i mb_v_mp4/monarch_butterfly_audio.mp4 -f dash -min_seg_duration 60 -init_seg_name 'mb_file.m4s' mpd/monarch_butterfly.mpd

ffmpeg -i mb_v_mp4/monarch_butterfly_audio.mp4 mpd/monarch_butterfly.mpd
