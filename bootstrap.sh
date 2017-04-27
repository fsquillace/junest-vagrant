#!/bin/bash

set -eu

# ArchLinux System initialization
pacman --noconfirm -Syu
pacman -S --noconfirm base-devel
# yajl is required for compiling package-query
pacman -S --noconfirm git arch-install-scripts haveged aws-cli yajl

cd /
sudo -u vagrant bash << EOF
git config --global user.email "builder@junest.org"
git config --global user.name "builder"

# AWS configuration
mkdir -p \${HOME}/.aws
cat /vagrant/aws-credentials > \${HOME}/.aws/credentials
cat /vagrant/aws-config > \${HOME}/.aws/config
EOF
