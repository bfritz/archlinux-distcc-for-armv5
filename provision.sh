#!/bin/sh

DISTCC_NET="172.64.1.0/24"

pacman -Syy
pacman -S --noconfirm --needed git

su - vagrant -c '/bin/sh /vagrant/distcc-alarm.sh'

pacman -U --noconfirm /tmp/distccd-alarm-armv5-*.pkg.tar.xz \
    && (sed -i "s,--allow 192.168.11.0/24,--allow ${DISTCC_NET}," /etc/conf.d/distccd-armv5) \
    && systemctl enable distccd-armv5 \
    && systemctl start  distccd-armv5
