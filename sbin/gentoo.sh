#!/bin/busybox sh

# Mount the /proc and /sys filesystems.
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

rescue_shell() {
	echo "Something went wrong. Dropping you to a shell."
	busybox --install -s
	exec /bin/sh
}
load_modules() {
	MOD_PATH="/lib/modules"
	for MODULE in "`find ${MOD_PATH} -maxdepth 1 -name '*.ko'`" ; do
		insmod -f ${MODULE}
	done
}
nfs_get_cmd() {
	cat /proc/cmdline|sed -r 's/.*nfsroot=([^:]+):([^,]+),([^ \t]+).*/mount -o \3 \1:\2 \/mnt\/root/g'
	#echo "root=/dev/nfs nfsroot=192.168.1.112:/home/nfs/amd64_arch,vers=3,rsize=8192,wsize=8192"|sed -r 's/.*nfsroot=([^:]+):([^,]+),([^ \t]+).*/mount -o \3 \1:\2 \/mnt\/root/g'
}
uuidlabel_root() {
	for cmd in $(cat /proc/cmdline) ; do
		case $cmd in
		root=*)
			dev=${cmd#root=}
			type=${dev%%=*}
			if [ $type = "LABEL" ] || [ $type = "UUID" ] ; then
				mount -o ro $(findfs "$dev") /mnt/root
			elif [ $dev = "/dev/nfs" ] ; then
				udhcpc -i enp4s0 -q
				nfs_cmd = nfs_get_cmd
				$(nfs_cmd)
			else
				mount -o ro ${dev} /mnt/root
			fi
			;;
		esac
	done
}

# Mount the root filesystem.
(modprobe wl && modprobe r8168 && modprobe nvidia && uuidlabel_root) || rescue_shell

# Clean up.
umount /proc
umount /sys
umount /dev

# Boot the real thing.
exec switch_root /mnt/root /sbin/init
