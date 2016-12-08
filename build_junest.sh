#!/bin/bash

set -eu

MAX_OLD_IMAGES=5

# ARCH can be one of: x86, x86_64, arm
HOST_ARCH=$(uname -m)
if [ $HOST_ARCH == "i686" ] || [ $HOST_ARCH == "i386" ]
then
    ARCH="x86"
elif [ $HOST_ARCH == "x86_64" ]
then
    ARCH="x86_64"
elif [[ $HOST_ARCH =~ .*(arm).* ]]
then
    ARCH="arm"
else
    echo "Unknown architecture ${HOST_ARCH}" >&2
    exit 11
fi

JUNEST_BUILDER=${HOME}/junest-builder

# Cleanup and initialization
[ -e "${JUNEST_BUILDER}" ] && sudo rm -rf ${JUNEST_BUILDER}
mkdir -p ${JUNEST_BUILDER}/tmp
trap "sudo rm -rf ${JUNEST_BUILDER}" EXIT QUIT ABRT KILL TERM INT

# ArchLinux System initialization
sudo pacman -Syu --noconfirm
yaourt -S --noconfirm junest-git

sudo systemctl start haveged

# Building JuNest image
cd ${JUNEST_BUILDER}
JUNEST_TEMPDIR=${JUNEST_BUILDER}/tmp /opt/junest/bin/junest -b

# Upload image
for img in $(ls junest-*.tar.gz);
do
    droxi put -f -O /Public/junest ${img}
done

DATE=$(date +'%Y-%m-%d-%H-%M-%S')

for img in $(ls junest-*.tar.gz);
do
    mv ${img} "${img}.${DATE}"
    droxi put -E -f -O /Public/junest "${img}.${DATE}"
done

# Cleanup old images
droxi ls /Public/junest/junest-${ARCH}.tar.gz.* | sed 's/ .*$//' | head -n -${MAX_OLD_IMAGES} | xargs -I {} droxi rm "{}"
