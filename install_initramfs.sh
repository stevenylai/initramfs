#!/bin/bash
INITRAMFS="initramfs-`eselect kernel show|grep linux|sed 's/^[^0-9]*//g'`.cpio.lzma"
if [ -f /boot/${INITRAMFS} ]; then
	mv /boot/${INITRAMFS} /boot/${INITRAMFS}.old
fi
cd /usr/src/initramfs
find . -print0 | cpio --null -ov --format=newc | lzma -9 > /boot/${INITRAMFS}
