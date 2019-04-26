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

mv $IMG_FILE $IMG_FILE_RENAMED

LOOPDEV=$(losetup -f)
losetup -P "$LOOPDEV" $IMG_FILE_RENAMED

mkdir root
mkdir boot

echo Mounting...
mount "${LOOPDEV}p1" boot
mount "${LOOPDEV}p2" root

for overlay in $PIBUILDERDIR/overlays/*.sh; do
    echo "Applying overlay: $overlay"
    $overlay
done;

echo Unmounting...
umount boot
umount root

cd ..


# TODO: Upload the image and delete the subvolume when done.
# echo Deleting subvolume...
# btrfs subvolume delete $WORKDIR

losetup -d "$LOOPDEV"
echo Done.
