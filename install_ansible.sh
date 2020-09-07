#!/bin/bash
apt-get -y update
apt -y install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt -y install ansible
apt -y install mysql-client-core-5.7
