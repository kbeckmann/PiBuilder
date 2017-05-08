#!/bin/bash

btrfs subvolume create base

cd base
echo Downloading the latest raspbian lite
wget https://downloads.raspberrypi.org/raspbian_lite_latest
unzip raspbian_lite_latest

echo Done
cd ..
