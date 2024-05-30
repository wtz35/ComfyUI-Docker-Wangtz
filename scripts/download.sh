#!/bin/bash

echo "########################################"
echo "[INFO] Downloading ComfyUI & Manager..."
echo "########################################"

set -euxo pipefail

# ComfyUI
cd /home/runner
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/comfyanonymous/ComfyUI.git \
    || (cd /home/runner/ComfyUI && git pull)

# ComfyUI Manager
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/ltdrdata/ComfyUI-Manager.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-Manager && git pull)

# ComfyUI_Custom_Nodes_AlekPet
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI_Custom_Nodes_AlekPet && git pull)

# ComfyUI-WD14-Tagger
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-WD14-Tagger && git pull)

# ComfyUI_IPAdapter_plus
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/cubiq/ComfyUI_IPAdapter_plus.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI_IPAdapter_plus && git pull)

# ComfyUI_essentials
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/cubiq/ComfyUI_essentials.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI_essentials && git pull)

# ComfyUI_LayerStyle
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/chflame163/ComfyUI_LayerStyle.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI_LayerStyle && git pull)

# ComfyUI-Easy-Use
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/yolain/ComfyUI-Easy-Use.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-Easy-Use && git pull)

# rembg-comfyui-node-better
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/Loewen-Hob/rembg-comfyui-node-better.git \
    || (cd /home/runner/ComfyUI/custom_nodes/rembg-comfyui-node-better && git pull)

# rembg-comfyui-node
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/Jcd1230/rembg-comfyui-node.git \
    || (cd /home/runner/ComfyUI/custom_nodes/rembg-comfyui-node && git pull)

# batchImg-rembg-ComfyUI-nodes
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/Mamaaaamooooo/batchImg-rembg-ComfyUI-nodes.git \
    || (cd /home/runner/ComfyUI/custom_nodes/batchImg-rembg-ComfyUI-nodes && git pull)

# ComfyUI-layerdiffuse
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/huchenlei/ComfyUI-layerdiffuse.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-layerdiffuse && git pull)

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# Models
cd /home/runner/ComfyUI
aria2c --input-file=/home/scripts/download.txt \
    --allow-overwrite=false --auto-file-renaming=false --continue=true \
    --max-connection-per-server=5

# Finish
touch /home/runner/.download-complete
