FROM python:3.10

# Ensure all python/python3 commands point to python3.10 for all users
RUN ln -sf /usr/local/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/local/bin/python3.10 /usr/bin/python3 && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip3

RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6 acl -y
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python

# Set HOME to /tmp for all users
ENV HOME=/tmp

ENV DL_PYTHON_EXECUTABLE=/usr/bin/python3.10

# Add /tmp/.local/bin to PATH so user-installed scripts are accessible
ENV PATH="/tmp/.local/bin:${PATH}"

# Install Python packages system-wide as root so any user can access them
RUN /usr/local/bin/python3.10 -m pip install --upgrade pip && \
    /usr/local/bin/python3.10 -m pip install --no-cache-dir \
    'numpy<1.22,>=1.16.2' \
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

# Set umask 0000 for all users and sessions so any created file/directory is world-writable
RUN echo 'umask 0000' >> /etc/bash.bashrc && \
    echo 'umask 0000' >> /etc/profile && \
    echo 'session optional pam_umask.so umask=0000' >> /etc/pam.d/common-session 2>/dev/null || true

# Make /tmp and EVERYTHING inside it accessible by all users (recursively)
# This includes any directories created by pip during package installation
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv
# docker build --platform linux/amd64  --pull --rm -f 'dockerfiles/cpu/python3.10/cpu.python3.10.opencv.Dockerfile' -t 'dtlpyagent:latest' . 
# docker tag dtlpyagent:latest hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv_no_user
# docker push hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv_no_user