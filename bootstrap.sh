#!/bin/bash

set -eu

# ArchLinux System initialization
sudo pacman -Syu --noconfirm
pacman -S --noconfirm git haveged aws-cli

cd /
sudo -u vagrant bash << EOF
git config --global user.email "builder@junest.org"
git config --global user.name "builder"

# AWS configuration
mkdir -p \${HOME}/.aws
cat /vagrant/aws-credentials > \${HOME}/.aws/credentials
cat /vagrant/aws-config > \${HOME}/.aws/config
EOF
