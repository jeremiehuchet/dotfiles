#!/bin/sh

source /opt/ansible/bin/activate

basedir=$(cd $(dirname $0) ; pwd)

(
  set -e
  cd $basedir
  ansible-playbook configure.yml $*
)
