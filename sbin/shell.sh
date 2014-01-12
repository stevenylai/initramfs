#!/bin/busybox sh

# Mount the /proc and /sys filesystems.
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

rescue_shell() {
	echo "Opening a shell."
	busybox --install -s
	exec /bin/sh
}

# Run the shell
rescue_shell

# Clean up.
umount /proc
umount /sys
umount /dev
