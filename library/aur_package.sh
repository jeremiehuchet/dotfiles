#!/bin/bash

source $1

pacman_stdout=$(pacman -Qi $name)
rc=$?

if [ $rc -eq 0 ] ; then
   cat - <<EOF
{
  "changed": false,
  "msg": "package $name is present"
}
EOF
else
   cat - <<EOF
{
  "failed": true,
  "msg": "package $name is missing, install with 'yaourt -Sy $name'"
}
EOF
fi
