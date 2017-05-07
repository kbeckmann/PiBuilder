#!/bin/bash
set -eu -o pipefail

echo "Patching config.txt"
cat << EOF >> boot/config.txt

# Enable USB Gadgets
dtoverlay=dwc2
EOF

echo "Patching cmdline.txt"
sed -i "s/rootwait/rootwait modules-load=dwc2,g_serial/" boot/cmdline.txt

