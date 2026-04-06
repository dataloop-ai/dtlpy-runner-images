FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
LABEL maintainer="Dataloop Team <info@dataloop.ai>"
ENV DEBIAN_FRONTEND='noninteractive'

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    locales \
    git \
    wget \
    bzip2 \
    curl \
    software-properties-common \
    python3.10 \
    python3.10-venv \
    python3-pip \
    python3-tk \
    python3-opengl \
    acl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure all python/python3 commands point to python3.10 for all users
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3


RUN mkdir -p /src
ENV PYTHONPATH="$PYTHONPATH:/src"

# fix for other languages issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set HOME to /tmp for all users
ENV HOME=/tmp

ENV DL_PYTHON_EXECUTABLE=/usr/bin/python3.10
ENV PIP_NO_CACHE_DIR=1

# Add /tmp/.local/bin to PATH so user-installed scripts are accessible
ENV PATH="/tmp/.local/bin:${PATH}"

# Install Python packages system-wide as root so any user can access them
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip && \
    ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'pip>=26.0' \
    'setuptools>=82.0' \
    'wheel>=0.46.2'

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'Cython>=3.0.0' \
    'imgaug==0.4.0' \
    'ffmpeg-python' \
    'tornado==6.5.5' \
    'opencv-python-headless>=4.13.0' \
    'Pillow>=12.0.0' \
    'numpy>=1.26.0,<2' \
    'scipy' \
    'scikit-image' \
    'scikit-learn>=1.8.0' \
    'psutil>=7.0.0' \
    'websocket-client==1.9.0' \
    'certifi>=2026.2.25' \
    'aiohttp>=3.13.0,<4' \
    'requests-toolbelt==1.0.0' \
    'requests>=2.32.0,<3' \
    'pandas>=2.2.0,<3' \
    'tabulate==0.10.0' \
    'tqdm>=4.67.0' \
    'PyJWT<=1.7.1' \
    'jinja2>=3.1.6,<4' \
    'attrs>=26.0.0' \
    'prompt_toolkit>=3.0.50' \
    'fuzzyfinder<=2.3.0' \
    'dictdiffer>=0.9.0' \
    'validators>=0.35.0' \
    'pathspec>=1.0.0' \
    'filelock>=3.25.0' \
    'redis>=5.0.0,<6' \
    'pydantic>=2.12.0,<3'


# Make /tmp accessible: existing files (chmod) + future files (setfacl default ACL)
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp && \
    setfacl -R -m d:o::rwx /tmp

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_opencv
