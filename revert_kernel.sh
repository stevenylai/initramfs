#!/bin/bash
PREV=`find /boot/ -name '*.old'`
for ITEM in ${PREV}
do
    CUR=`echo ${ITEM}|sed 's/\.old$//g'`
    echo "mv ${ITEM} ${CUR}"
    mv ${ITEM} ${CUR}
done
echo "cp /boot/config-*-gentoo /usr/src/linux/.config"
cp /boot/config-*-gentoo /usr/src/linux/.config
