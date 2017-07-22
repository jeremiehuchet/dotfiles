#!/bin/sh

source /opt/ansible/bin/activate

if [ $# -eq 0 ] ; then
    ask="--ask-sudo-pass"
fi

ansible-playbook configure.yml $ask $*
