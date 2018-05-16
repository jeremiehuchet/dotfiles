#!/bin/sh
# {{ generated_tag }}

function print() {
  echo $1
  echo $2
}

if [ "$(cat /sys/devices/platform/applesmc.768/fan1_manual)" == "1" ] && [ "$(cat /sys/devices/platform/applesmc.768/fan2_manual)" == "1" ] ; then
  print  '#585858'
else
  print  '#ff0000'
fi
