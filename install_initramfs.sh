#!/bin/bash
#INITRAMFS="initramfs-`eselect kernel show|grep linux|sed 's/^[^0-9]*//g'`.cpio.lzma"
INITRAMFS="initramfs-`eselect kernel show|grep linux|sed 's/^[^0-9]*//g'`.cpio.xz"
if [ -f /boot/${INITRAMFS} ]; then
	mv /boot/${INITRAMFS} /boot/${INITRAMFS}.old
fi
cd /usr/src/initramfs
#find . -print0 | cpio --null -ov --format=newc | lzma -9 > /boot/${INITRAMFS}
find . -print0 | cpio --null -ov --format=newc | xz --check=crc32 --lzma2=dict=512KiB > /boot/${INITRAMFS}
