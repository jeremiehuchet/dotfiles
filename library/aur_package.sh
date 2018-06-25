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
   aurman --noconfirm -Sy $name
   if [ $? -eq 0 ] ; then
     cat - <<EOF
{
  "changed": true,
  "msg": "package $name has been installed"
}
EOF
   else
     cat - <<EOF
{
  "failed": true,
  "msg": "package $name is missing, install with 'aurman -Sy $name'"
}
EOF
  fi
fi
