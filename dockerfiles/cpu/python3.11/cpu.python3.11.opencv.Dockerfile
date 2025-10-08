FROM python:3.11
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python

USER 1000
ENV HOME=/tmp
RUN /usr/local/bin/python -m pip install --upgrade pip && pip3 --no-cache-dir install \
    'numpy' \
    'scipy' \
    'scikit-image' \
    'py3nvml' \
    'pika==1.0.1' \
    'opencv-python-headless>=4.1.2' \
    'nms==0.1.6' \
    'imgaug==0.2.9' \
    'Pillow>=11.0.0' \
    'ffmpeg-python' \
    'tornado==6.0.2' \
    'psutil==5.6.7' \
    'certifi>=2020.12.5 ,<2021.10.8' \
    'webvtt-py==0.4.3' \
    'aiohttp>=3.6.2 , <4.0.0' \
    'requests-toolbelt==0.9.1' \
    'requests>=2.21.0, <2.26.0' \
    'pandas>=0.24.2, <1.4' \
    'tabulate==0.8.9' \
    'tqdm>=4.32.2, <4.62.3' \
    'PyJWT>=2.4' \
    'jinja2>=2.11.3, <3.0.2' \
    'attrs<20.0.0' \
    'prompt_toolkit>=2.0.9 , <3.0.20' \
    'fuzzyfinder<=2.1.0' \
    'dictdiffer>=0.8.1, <0.9.0' \
    'validators<=0.18.2' \
    'pathspec>=0.8.1 , <0.10' \
    'filelock>=3.0.12, <3.5.0' \
    'diskcache==5.2.1' \
    'redis==4.1.3' \
    'pydantic' \
    'websocket-client==1.2.3'

COPY code-server-installation.sh /tmp/code-server-installation.sh
RUN bash /tmp/code-server-installation.sh

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv
