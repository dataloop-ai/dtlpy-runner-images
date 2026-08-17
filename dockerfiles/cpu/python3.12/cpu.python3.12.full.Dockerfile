FROM python:3.12

ENV DL_PYTHON_EXECUTABLE=/usr/local/bin/python3.12
ENV PIP_NO_CACHE_DIR=1
ENV HOME=/tmp
ENV PATH="/tmp/.local/bin:${PATH}"

# Use Dell Artifactory PyPI mirror (avoids corporate proxy SSL interception)
ARG PIP_INDEX_URL=https://artifacts.dell.com/artifactory/api/pypi/python/simple
ARG PIP_TRUSTED_HOST=artifacts.dell.com

# System deps: symlinks, ffmpeg, acl
RUN ln -sf ${DL_PYTHON_EXECUTABLE} /usr/bin/python && \
    ln -sf ${DL_PYTHON_EXECUTABLE} /usr/bin/python3 && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip && \
    ln -sf /usr/local/bin/pip3 /usr/bin/pip3 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ffmpeg libsm6 libxext6 acl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# All Python packages in one layer — lets pip resolve the full dependency graph once.
# dtlpy pins attrs<25, validators<=0.18.2, fuzzyfinder<=2.1, webvtt-py==0.4.3
# so those are omitted here to avoid install-then-downgrade waste.
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip && \
    ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
    'setuptools>=82.0' \
    'wheel>=0.46.2' \
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
    'imgaug==0.4.0' \
    'Pillow>=12.0.0' \
    'ffmpeg-python' \
    'tornado==6.5.5' \
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

# docker build --platform linux/amd64 --pull --no-cache -f 'dockerfiles/cpu/python3.12/cpu.python3.12.full.Dockerfile' -t 'hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_full' .
# docker push hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_full
