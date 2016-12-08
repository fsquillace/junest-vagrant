#!/bin/bash

set -eu

# ArchLinux System initialization
pacman --noconfirm -Syu
pacman -S --noconfirm base-devel
pacman -S --noconfirm git arch-install-scripts haveged
useradd builder
mkdir /home/builder
chown builder /home/builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cd /
sudo -u builder bash << EOF
git config --global user.email "builder@junest.org"
git config --global user.name "builder"

JUNEST_BUILDER_TMPDIR=/tmp/junest-builder-tmp

# Cleanup and initialization
[ -e "\${JUNEST_BUILDER_TMPDIR}" ] && sudo rm -rf \${JUNEST_BUILDER_TMPDIR}
mkdir -p \${JUNEST_BUILDER_TMPDIR}

mkdir -p \${JUNEST_BUILDER_TMPDIR}/package-query
cd \${JUNEST_BUILDER_TMPDIR}/package-query
curl -L -J -O -k "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query"
makepkg --noconfirm -sfc
sudo pacman --noconfirm -U package-query*.pkg.tar.xz
mkdir -p \${JUNEST_BUILDER_TMPDIR}/yaourt
cd \${JUNEST_BUILDER_TMPDIR}/yaourt
curl -L -J -O -k "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yaourt"
makepkg --noconfirm -sfc
sudo pacman --noconfirm -U yaourt*.pkg.tar.xz
yaourt -S --noconfirm droxi
mkdir -p \${HOME}/.config/droxi
cat /vagrant/droxirc > \${HOME}/.config/droxi/droxirc

sudo rm -rf \${JUNEST_BUILDER_TMPDIR}
EOF
