#!/bin/sh

git clone https://github.com/WarheadsSE/PKGs.git
cd PKGs/distccd-alarm
makepkg -s --noconfirm --needed
cp -p *.pkg.tar.xz /tmp/
