#!/bin/bash
#
# {{ generated_tag }}
#
# https://wiki.archlinux.org/index.php/HiDPI
# Generically if your hidpi monitor is AxB pixels and your regular monitor is CxD and you are scaling by [ExF] and hidpi is placed below regular one, the commandline for right-of is:
# xrandr --output eDP-1 --auto --pos 0x(DxF) --output HDMI-1 --auto --scale [E]x[F] --pos 0x0 --fb [greater between A and (C*E)]x[B+(D*F)]

LAPTOP=eDP1
EXT=HDMI3

function fixup_overlap() {
  laptop_spec=$(xrandr | grep "^$LAPTOP" | sed -E 's/.* ([0-9]+x[0-9]+[+][0-9]+[+][0-9]+) .*/\1/g')
  laptop_x_padding=$(echo $laptop_spec | sed -E 's/.*[+]([0-9]+)[+].*/\1/g')
  laptop_y_padding=$(echo $laptop_spec | sed -E 's/.*[+]([0-9]+)$/\1/g')
  ext_spec=$(xrandr | grep "^$EXT" | sed -E 's/.* ([0-9]+x[0-9]+[+][0-9]+[+][0-9]+) .*/\1/g')
  ext_width=$(echo $ext_spec | sed -E 's/^([0-9]+)x.*/\1/g')
  ext_height=$(echo $ext_spec | sed -E 's/.*x([0-9]+)[+].*/\1/g')
  ext_x_padding=$(echo $ext_spec | sed -E 's/.*[+]([0-9]+)[+].*/\1/g')
  ext_y_padding=$(echo $ext_spec | sed -E 's/.*[+]([0-9]+)$/\1/g')

  if [ "_$1" == "_horizontal" ] ; then
    xrandr --output $LAPTOP --pos ${ext_width}x${ext_x_padding}
  elif [ "_$1" == "_vertical" ] ; then
    xrandr --output $LAPTOP --pos ${ext_y_padding}x${ext_height}
  else
    # laptop overlaps ext horizontally
    if [ $ext_x_padding -lt $laptop_x_padding ] && [ $ext_width -ge $laptop_x_padding ] ; then
      xrandr --output $LAPTOP --pos ${ext_width}x${ext_x_padding}
    # laptop overlaps ext vertically
    elif [ $ext_y_padding -lt $laptop_y_padding ] && [ $ext_height -ge $laptop_y_padding ] ; then
      xrandr --output $LAPTOP --pos ${ext_y_padding}x${ext_height}
    # horizontal blank between ext and laptop
    elif [ $ext_x_padding -lt $laptop_x_padding ] && [ $ext_width -lt $laptop_x_padding ] ; then
      xrandr --output $LAPTOP --pos ${ext_width}x${ext_x_padding}
    # vertial blank betweel ext and laptop
    elif [ $ext_y_padding -lt $laptop_y_padding ] && [ $ext_height -lt $laptop_y_padding ] ; then
      xrandr --output $LAPTOP --pos ${ext_y_padding}x${ext_height}
    fi
  fi
}

cmd=$1

case $cmd in
  laptop-only)
    xrandr --output $LAPTOP --auto --output $EXT --off
    ;;
  above-laptop)
    xrandr --output $LAPTOP --auto --output $EXT --auto --above $LAPTOP
    fixup_overlap vertical
    ;;
  right-of-laptop)
    xrandr --output $LAPTOP --auto --output $EXT --auto --right-of $LAPTOP
    ;;
  below-laptop)
    xrandr --output $LAPTOP --auto --output $EXT --auto --below $LAPTOP
    ;;
  left-of-laptop)
    xrandr --output $LAPTOP --auto --output $EXT --auto --left-of $LAPTOP
    fixup_overlap horizontal
    ;;
  zoom-in)
    xrandr --output $EXT --scale 1x1
    fixup_overlap
    ;;
  zoom-out)
    xrandr --output $EXT --scale 1.35x1.35
    fixup_overlap
    ;;
  *)
    logger -t $0 "unknown command: $cmd"
    ;;
esac
