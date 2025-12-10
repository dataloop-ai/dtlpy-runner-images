FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
MAINTAINER Dataloop Team <info@dataloop.ai>
ENV DEBIAN_FRONTEND='noninteractive'

RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    git \
    wget \
    bzip2 \
    curl \
    software-properties-common \
    python3.11 \
    python3.11-venv \
    python3-pip \
    python3-tk \
    python3-opengl 

# Ensure all python/python3 commands point to python3.11 for all users
RUN ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3


RUN mkdir -p /src
ENV PYTHONPATH="$PYTHONPATH:/src"

# fix for other languages issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set HOME to /tmp for all users
ENV HOME=/tmp

ENV DL_PYTHON_EXECUTABLE=/usr/bin/python3.11
ENV PIP_NO_CACHE_DIR=1

# Add /tmp/.local/bin to PATH so user-installed scripts are accessible
ENV PATH="/tmp/.local/bin:${PATH}"

# Install Python packages system-wide as root so any user can access them
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade setuptools

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'Cython>=0.29' \
    'numpy>=2.0,<3' \
    'imgaug' \
    'ffmpeg-python' \
    'tornado==6.0.2' \
    'opencv-python-headless>=4.1.2' \
    'Pillow>=11.0.0' \
    'scipy' \
    'scikit-image' \
    'scikit-learn' \
    'psutil' \
    'websocket-client==1.2.3' \
    'certifi>=2020.12.5 ,<2021.10.8' \
    'aiohttp>=3.6.2 , <4.0.0' \
    'requests-toolbelt==0.9.1' \
    'requests>=2.21.0, <2.26.0' \
    'pandas' \
    'tabulate' \
    'tqdm>=4.32.2, <4.62.3' \
    'PyJWT<=1.7.1' \
    'jinja2>=2.11.3, <3.0.2' \
    'attrs<20.0.0' \
    'prompt_toolkit>=2.0.9 , <3.0.20' \
    'fuzzyfinder<=2.1.0' \
    'dictdiffer>=0.8.1, <0.9.0' \
    'validators<=0.18.2'\
    'pathspec>=0.8.1 , <0.10' \
    'filelock>=3.0.12, <3.5.0' \
    'diskcache==5.2.1' \
    'redis==4.1.3' \
    'pydantic'


# Set umask 0000 for all users and sessions so any created file/directory is world-writable
RUN echo 'umask 0000' >> /etc/bash.bashrc && \
    echo 'umask 0000' >> /etc/profile && \
    echo 'session optional pam_umask.so umask=0000' >> /etc/pam.d/common-session 2>/dev/null || true

# Make /tmp and EVERYTHING inside it accessible by all users (recursively)
# This includes any directories created by pip during package installation
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.11_cuda11.8_opencv
