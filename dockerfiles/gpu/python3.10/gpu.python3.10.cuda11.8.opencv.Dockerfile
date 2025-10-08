FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
MAINTAINER Dataloop Team <info@dataloop.ai>
ENV DEBIAN_FRONTEND='noninteractive'
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    git \
    wget \
    bzip2 \
    software-properties-common \
    python3.10 \
    python3.10-venv \
    python3-pip \
    python3-tk \
    python3-opengl

RUN mkdir -p /src
ENV PYTHONPATH="$PYTHONPATH:/src"
# fix for other languages issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools

RUN pip3 --no-cache-dir install \
    'Cython>=0.29' \
    'imgaug' \
    'ffmpeg-python' \
    'tornado==6.0.2' \
    'opencv_python' \
    'Pillow>=11.0.0' \
    'numpy<1.22 , >=1.16.2' \
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

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_opencv