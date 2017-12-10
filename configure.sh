#!/bin/sh

source /opt/ansible/bin/activate

ansible-playbook configure.yml $*
