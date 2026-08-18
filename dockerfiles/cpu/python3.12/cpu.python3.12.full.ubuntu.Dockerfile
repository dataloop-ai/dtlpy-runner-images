FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DL_PYTHON_EXECUTABLE=/usr/bin/python3.12
ENV PIP_NO_CACHE_DIR=1
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV HOME=/tmp
ENV PATH="/tmp/.local/bin:${PATH}"

# Use Dell Artifactory PyPI mirror (avoids corporate proxy SSL interception)
ARG PIP_INDEX_URL=https://artifacts.dell.com/artifactory/api/pypi/python/simple
ARG PIP_TRUSTED_HOST=artifacts.dell.com

# System deps: python3.12 (no pip - we install it manually), ffmpeg, acl — single layer, minimal
# No build-essential/dev headers — all packages have pre-built manylinux wheels.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        python3.12 \
        curl \
        ffmpeg \
        libsm6 \
        libxext6 \
        acl \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/bin/python3.12 /usr/bin/python && \
    ln -sf /usr/bin/python3.12 /usr/bin/python3 && \
    # Install pip via standalone installer (no system python3-pip = no CVEs)
    curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.12 /tmp/get-pip.py --index-url https://artifacts.dell.com/artifactory/api/pypi/python/simple --trusted-host artifacts.dell.com && \
    rm /tmp/get-pip.py && \
    apt-get purge -y curl && \
    apt-get autoremove -y

# All Python packages in one layer — lets pip resolve the full dependency graph once.
# dtlpy pins attrs<25, validators<=0.18.2, fuzzyfinder<=2.1, webvtt-py==0.4.3
# so those are omitted here to avoid install-then-downgrade waste.
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --break-system-packages --no-cache-dir \
    # --- Dataloop SDK + web framework ---
    'dtlpy' \
    'fastapi' \
    'uvicorn' \
    'python-multipart' \
    # --- Core runner dependencies ---
    'numpy' \
    'scipy' \
    'scikit-image' \
    'scikit-learn>=1.7.0,<1.8' \
    'py3nvml==0.2.7' \
    'pika==1.3.2' \
    'opencv-python-headless>=4.13.0' \
    'nms==0.1.6' \
    'Pillow>=12.0.0' \
    'ffmpeg-python' \
    'tornado==6.5.7' \
    'psutil>=7.0.0' \
    'certifi>=2026.2.25' \
    'aiohttp>=3.13.0,<4' \
    'requests-toolbelt==1.0.0' \
    'requests>=2.32.0,<3' \
    'pandas>=2.2.0,<3' \
    'tabulate==0.10.0' \
    'tqdm>=4.67.0' \
    'PyJWT>=2.12.0' \
    'jinja2>=3.1.6,<4' \
    'prompt_toolkit>=3.0.50' \
    'dictdiffer>=0.9.0' \
    'pathspec>=1.0.0' \
    'filelock>=3.25.0' \
    'redis>=5.0.0,<6' \
    'pydantic>=2.12.0,<3' \
    'websocket-client==1.9.0' \
    # --- CV and ML inference ---
    'pycocotools' \
    'matplotlib' \
    'onnxruntime' \
    'onnx' \
    'faiss-cpu' \
    'transformers>=4.37.0' \
    'huggingface-hub' \
    # --- Video processing ---
    'imageio' \
    # --- Utilities ---
    'nest_asyncio' \
    'pyyaml>=5.3.1' \
    'openai' \
    'httpx' \
    'plotly' \
    'pyarrow' \
    # --- Donna v3 + Slack app ---
    'python-dotenv' \
    'aiosqlite' \
    'slack-bolt' \
    'langchain-core>=1.0.5' \
    'langchain-openai' \
    'json-repair' \
    'markdown-to-mrkdwn'

# Make /tmp accessible: existing files (chmod) + future files (setfacl default ACL)
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp && \
    setfacl -R -m d:o::rwx /tmp

# docker build --platform linux/amd64 --pull --no-cache -f 'dockerfiles/cpu/python3.12/cpu.python3.12.full.ubuntu.Dockerfile' -t 'cpu-python3.12-full-ubuntu:latest' .
# docker push hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_full_test
