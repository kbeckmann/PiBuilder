#!/bin/bash
set -eu -o pipefail

pushd root/etc/systemd/system/multi-user.target.wants

echo Symlinking wpa_supplicant.service
ln -s ../../../../lib/systemd/system/wpa_supplicant.service

echo Symlinking ssh.service
ln -s ../../../../lib/systemd/system/ssh.service

echo Symlinging getty@ttyGSS0.service
cd ../getty.target.wants
ln -s /lib/systemd/system/getty@.service getty@ttyGS0.service

popd

echo Copying overlay files for rootfs
TARGET=$(pwd)/root
pushd ../overlays/root
echo Executing cp...
cp --parents -a * $TARGET
echo Done..
popd

