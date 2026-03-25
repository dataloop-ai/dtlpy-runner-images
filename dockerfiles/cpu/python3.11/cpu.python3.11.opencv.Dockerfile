FROM python:3.11

ENV DL_PYTHON_EXECUTABLE=/usr/local/bin/python3.11
ENV PIP_NO_CACHE_DIR=1

# Ensure all python/python3 commands point to python3.11 for all users
RUN ln -sf ${DL_PYTHON_EXECUTABLE} /usr/bin/python && \
    ln -sf ${DL_PYTHON_EXECUTABLE} /usr/bin/python3 && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip3

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ffmpeg libsm6 libxext6 acl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN CODESERVER_VERSION=4.112.0 && \
    curl -fsSL -o /tmp/code-server.deb \
        "https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb" && \
    echo "28c85f281304de6fb88a69e8d92e4baed3b99070a8f010b747667b39e5bae2ae  /tmp/code-server.deb" | sha256sum -c - && \
    dpkg -i /tmp/code-server.deb && \
    rm /tmp/code-server.deb
RUN code-server --install-extension ms-python.python

# Set HOME to /tmp for all users
ENV HOME=/tmp

# Add /tmp/.local/bin to PATH so user-installed scripts are accessible
ENV PATH="/tmp/.local/bin:${PATH}"

# Install Python packages system-wide as root so any user can access them
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip && \
    ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'pip>=26.0' \
    'setuptools>=82.0' \
    'wheel>=0.46.2'

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'numpy>=2.4.0,<3' \
    "pandas>=2.2,<3" \
    'scipy' \
    'scikit-image' \
    'py3nvml' \
    'pika==1.3.2' \
    'opencv-python-headless>=4.1.2' \
    'nms==0.1.6' \
    'imgaug==0.4.0' \
    'Pillow>=12.0.0' \
    'ffmpeg-python' \
    'tornado==6.5.5' \
    'psutil>=7.0.0' \
    'certifi>=2026.2.25' \
    'webvtt-py==0.5.1' \
    'aiohttp>=3.13.0,<4' \
    'requests-toolbelt==1.0.0' \
    'requests>=2.32.0,<3' \
    'tabulate==0.10.0' \
    'tqdm>=4.67.0' \
    'PyJWT>=2.12.0' \
    'jinja2>=3.1.6,<4' \
    'attrs>=26.0.0' \
    'prompt_toolkit>=3.0.50' \
    'fuzzyfinder<=2.3.0' \
    'dictdiffer>=0.9.0' \
    'validators>=0.35.0' \
    'pathspec>=1.0.0' \
    'filelock>=3.25.0' \
    'diskcache==5.6.3' \
    'redis>=5.0.0,<6' \
    'pydantic>=2.12.0' \
    'websocket-client==1.9.0'

COPY code-server-installation.sh /tmp/code-server-installation.sh
RUN bash /tmp/code-server-installation.sh

# Make /tmp accessible: existing files (chmod) + future files (setfacl default ACL)
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp && \
    setfacl -R -m d:o::rwx /tmp

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv
