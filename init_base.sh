#!/bin/bash

mkdir base
cd base
echo Downloading the latest raspbian lite
curl wget https://downloads.raspberrypi.org/raspbian_lite_latest | bsdtar -xvf-

echo Done
cd ..
