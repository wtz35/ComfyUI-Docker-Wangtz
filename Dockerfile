################################################################################
# Dockerfile that builds 'wangtz/comfyui-boot:latest'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="wangtz"

# Note: GCC for InsightFace;
#       FFmpeg for video (pip[imageio-ffmpeg] will use system FFmpeg instead of bundled).
# Note: CMake may use different version of Python. Using 'update-alternatives' to ensure default version.
RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
            install --no-confirm \
        python311 python311-pip python311-wheel python311-setuptools \
        python311-devel python311-Cython gcc-c++ python311-py-build-cmake \
        python311-numpy python311-opencv \
        python311-ffmpeg-python ffmpeg x264 x265 \
        python311-dbm \
        google-noto-sans-fonts google-noto-sans-cjk-fonts google-noto-coloremoji-fonts \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --upgrade pip wheel setuptools Cython numpy

# Install xFormers (stable version, will specify PyTorch version),
# and Torchvision + Torchaudio (will downgrade to match xFormers' PyTorch version).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

# Create a low-privilege user
RUN printf 'CREATE_MAIL_SPOOL=no' >> /etc/default/useradd \
    && mkdir -p /home/runner /home/scripts \
    && groupadd runner \
    && useradd runner -g runner -d /home/runner \
    && chown runner:runner /home/runner /home/scripts

# 安装 wget
RUN zypper refresh && \
zypper install -y wget && \
zypper clean -a

USER runner:runner

WORKDIR /home/models/sdxl
# sdxl
RUN wget -O bluePencilXL_v600.safetensors https://huggingface.co/bluepen5805/blue_pencil-XL/resolve/main/blue_pencil-XL-v6.0.0.safetensors

RUN wget -O holodayo-xl-2.1.safetensors https://huggingface.co/yodayo-ai/holodayo-xl-2.1/resolve/main/holodayo-xl-2.1.safetensors

RUN wget -O duchaitenPonyXLNo_ponyNoScoreV40.safetensors https://huggingface.co/LyliaEngine/Duchaiten_PonyXL-No_Pony-No_Score-V40/resolve/main/duchaitenPonyXLNo_ponyNoScoreV40.safetensors

RUN wget -O hadrianDelicexlPony_v20l.safetensors https://huggingface.co/Junity/hadrianDelicexlPony_v20l/resolve/main/hadrianDelicexlPony_v20l.safetensors

RUN wget -O duchaitenPonyReal_ponyRealV10.safetensors https://huggingface.co/wtz37/2.5d/resolve/main/duchaitenPonyReal_ponyRealV10.safetensors

RUN wget -O animagineXLV31_v31.safetensors https://huggingface.co/wtz37/yinv_model/resolve/main/animagineXLV31_v31.safetensors

WORKDIR /home/models/IPAdapter_sdxl
# IPAdapter sdxl
RUN wget -O ip-adapter-plus_sdxl_vit-h.safetensors https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors

RUN wget -O ip-adapter-plus-face_sdxl_vit-h.safetensors https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus-face_sdxl_vit-h.safetensors

WORKDIR /home/models/contrlnet_sdxl
# contrlnet sdxl
RUN wget -O sdxl_openpose.safetensors https://huggingface.co/xinsir/controlnet-openpose-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors

RUN wget -O sdxl_canny.safetensors https://huggingface.co/xinsir/controlnet-canny-sdxl-1.0/resolve/main/diffusion_pytorch_model_V2.safetensors

WORKDIR /home/models/loras
# lora
RUN wget -O add-detail-xl.safetensors https://huggingface.co/wtz37/loras/resolve/main/add-detail-xl.safetensors

RUN wget -O feet_v3.safetensors https://huggingface.co/wtz37/loras/resolve/main/feet%20v3.safetensors

RUN wget -O flat-color-style_A3.1_XL.safetensors https://huggingface.co/wtz37/loras/resolve/main/flat-color-style_A3.1_XL.safetensors

RUN wget -O hand_4.safetensors https://huggingface.co/wtz37/loras/resolve/main/hand%204.safetensors

RUN wget -O perfection_style.safetensors https://huggingface.co/wtz37/loras/resolve/main/perfection%20style.safetensors

RUN wget -O sketch-style-xl.safetensors https://huggingface.co/wtz37/loras/resolve/main/sketch-style-xl.safetensors

RUN wget -O wrenchftmfshnxl.safetensors https://huggingface.co/wtz37/yinv_lora/resolve/main/wrenchftmfshnxl.safetensors


# VAE
WORKDIR /home/models/vae

RUN wget -O vae-ft-mse-840000-ema-pruned.safetensors https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors

WORKDIR /home/models/vae_approx

RUN wget -O taesd_decoder.safetensors https://huggingface.co/madebyollin/taesd/resolve/main/taesd_decoder.safetensors

RUN wget -O taesdxl_decoder.safetensors https://huggingface.co/madebyollin/taesdxl/resolve/main/taesdxl_decoder.safetensors


# Upscale
WORKDIR /home/models/upscale_models

RUN wget -O 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth

# Embeddings
WORKDIR /home/models/embeddings

RUN wget -O easynegative.safetensors https://huggingface.co/datasets/gsdf/EasyNegative/resolve/main/EasyNegative.safetensors

RUN wget -O ng_deepnegative_v1_75t.pt https://huggingface.co/lenML/DeepNegative/resolve/main/NG_DeepNegative_V1_75T.pt

# CLIP Vision
WORKDIR /home/models/clip_vision

RUN wget -O CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors https://huggingface.co/laion/CLIP-ViT-H-14-laion2B-s32B-b79K/resolve/main/model.safetensors

USER root

# Dependencies for frequently-used
# (Do this firstly so PIP won't be solving too many deps at one time)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
        -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt

# Dependencies for more, with few hand-pick:
# 'cupy-cuda12x' for Frame Interpolation
# 'compel lark' for smZNodes
# 'torchdiffeq' for DepthFM
# 'fairscale' for APISR
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt \
        cupy-cuda12x \
        -r https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt \
        -r https://raw.githubusercontent.com/MrForExample/ComfyUI-3D-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/storyicon/comfyui_segment_anything/main/requirements.txt \
        -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
        compel lark torchdiffeq fairscale \
        python-ffmpeg


# 自定义插件安装依赖
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/Jcd1230/rembg-comfyui-node/master/requirements.txt \
        -r https://raw.githubusercontent.com/pythongosssss/ComfyUI-WD14-Tagger/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/chflame163/ComfyUI_LayerStyle/main/requirements.txt \
        -r https://raw.githubusercontent.com/yolain/ComfyUI-Easy-Use/main/requirements.txt \
        -r https://raw.githubusercontent.com/Mamaaaamooooo/batchImg-rembg-ComfyUI-nodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/huchenlei/ComfyUI-layerdiffuse/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt


# # Additional deps for ComfyUI-3D-Pack (prebuilt by me)
# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install --break-system-packages \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/diff_gaussian_rasterization-0.0.0-cp311-cp311-linux_x86_64.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/kiui-0.2.7-py3-none-any.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/nvdiffrast-0.3.1-py3-none-any.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/pointnet2_ops-3.0.0-cp311-cp311-linux_x86_64.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/pytorch3d-0.7.6-cp311-cp311-linux_x86_64.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/simple_knn-0.0.0-cp311-cp311-linux_x86_64.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/torch_scatter-2.1.2-cp311-cp311-linux_x86_64.whl \
#         https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/torchmcubes-0.1.0-cp311-cp311-linux_x86_64.whl

# 1. Fix ONNX Runtime "missing CUDA provider". Also add support for CUDA 12.1.
#    Ref: https://onnxruntime.ai/docs/install/
# 2. Fix MediaPipe's broken dep (protobuf<4).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --force-reinstall onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
        --extra-index-url https://pypi.org/simple \
    && pip install --break-system-packages \
        mediapipe

# Fix for libs (.so files)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/lib64/python3.11/site-packages/torch/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_cupti/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_runtime/lib\
:/usr/lib/python3.11/site-packages/nvidia/cudnn/lib\
:/usr/lib/python3.11/site-packages/nvidia/cufft/lib"

# More libs (not necessary, just in case)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/lib/python3.11/site-packages/nvidia/cublas/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/lib/python3.11/site-packages/nvidia/curand/lib\
:/usr/lib/python3.11/site-packages/nvidia/cusolver/lib\
:/usr/lib/python3.11/site-packages/nvidia/cusparse/lib\
:/usr/lib/python3.11/site-packages/nvidia/nccl/lib\
:/usr/lib/python3.11/site-packages/nvidia/nvjitlink/lib\
:/usr/lib/python3.11/site-packages/nvidia/nvtx/lib"

COPY --chown=runner:runner scripts/. /home/scripts/
COPY --chown=runner:runner update/. /home/update/

# 强制安装特定版本的 numpy
RUN pip3 install --no-cache-dir numpy==1.26.4

USER runner:runner
VOLUME /home/runner
WORKDIR /home/runner
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/home/scripts/entrypoint.sh"]
