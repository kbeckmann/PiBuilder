#!/bin/bash
set -eu -o pipefail

PIBUILDERDIR=$(pwd)
BASEDIR=base/
WORKDIR=workdir-$(uuidgen)
IMG_FILE=$(cd $BASEDIR && ls *.img)
IMG_FILE_RENAMED=$(uuidgen).img

echo Creating subvolume $WORKDIR
btrfs subvolume snapshot $BASEDIR $WORKDIR
sync

cd $WORKDIR

# Need a unique filename to make kpartx happy
mv $IMG_FILE $IMG_FILE_RENAMED

# Use kpartx magic to set up loop devices for the partitions in the image
kpartx -a -s $IMG_FILE_RENAMED
BOOT_PART=/dev/mapper/$(kpartx -l $IMG_FILE_RENAMED | head -1 | awk '{print $1}')
ROOT_PART=/dev/mapper/$(kpartx -l $IMG_FILE_RENAMED | head -2 | tail -1 | awk '{print $1}')

echo Boot: $BOOT_PART
echo Root: $ROOT_PART

mkdir root
mkdir boot

echo Mounting...
mount $BOOT_PART boot
mount $ROOT_PART root

for overlay in $PIBUILDERDIR/overlays/*.sh; do
    echo "Applying overlay: $overlay"
    $overlay
done;

echo Unmounting...
umount boot
umount root
kpartx -d $IMG_FILE_RENAMED

cd ..


# TODO: Upload the image and delete the subvolume when done.
# echo Deleting subvolume...
# btrfs subvolume delete $WORKDIR

echo Done.
