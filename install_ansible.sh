#!/bin/bash
apt-get -y update
apt -y install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt -y install ansible
