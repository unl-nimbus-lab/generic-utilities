#! /bin/bash
# Generic one-liner for recording all/part of an X11 window.
# Adjust the variables (empirically) to suit your needs. More
# customised fine-tuning, such as precise cropping can be done
# after-the-fact, using the same low-level utilities or perhaps
# something fancier like iMovie. Dual-monitor support is a little
# tricky (adjust numbers).
# A little "documentation" :
#   x-axis/y-axis : horizontal/vertical span of the display
#   origin        : top-left corner (positive-y is downwards)
#   -i 0.0        : display0 (second monitor is *not* display1, sadly..)
#   $1            : file name ("blah.mp4")
# Higher framerate might make it sluggish (try increasing threads).
# Install `avconv` or `ffmepg` from repositories.
# Display servers other than X11 will probably not work ("x11grab").
#
# -- aj / NimbusLab / Sept 2019.


## ------------ EDIT VALUES HERE ----------------##
videores_x=750            # horizontal px
videores_y=540            # vertical px
offset_topleft_x=0        # start recording at this corner
offset_topleft_y=70       # start recording at this corner

# sometimes useful to do some math adjustments?
## effective_x=$(($videores_x - $off_x))
## effective_y=$(($videores_y - $off_y))

# check if ffmpeg or avconv
if hash ffmpeg 2>/dev/null; then
  ENCODER_PROGRAM="ffmpeg";
elif hash avconv 2>/dev/null; then
  ENCODER_PROGRAM="avconv";
else
  echo "Install avconv or ffmpeg!\n";
  return 0;
fi

# actual good stuff
$ENCODER_PROGRAM -f x11grab -framerate 30 -video_size $videores_x\x$videores_y \
-i :0.0+$offset_topleft_x,$offset_topleft_y \
-vcodec h264 \
-acodec pcm_s16le \
-q 2 \
-threads 2 \
$1
