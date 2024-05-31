#!/bin/bash

echo "########################################"
echo "[INFO] Update relevant information..."
echo "########################################"

set -euxo pipefail

# cd /home/runner/ComfyUI
# aria2c --input-file=/home/scripts/update.txt \
#     --allow-overwrite=false --auto-file-renaming=false --continue=true \
#     --max-connection-per-server=5
# 

# Update ComfyUI
cp -r /home/update/* /home/runner/ComfyUI/input/

# Finish
touch /home/runner/.update-complete



