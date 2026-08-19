ARG BCI_BASE_IMAGE=durjpd.artifactory.cec.lab.emc.com/common-docker-remote/bci/bci-base:16.1

# Stage: download shell utilities required by the FaaS agent runner script.
# bci-minimal has no zypper, so we download RPMs on a bci-base stage and install
# them with rpm in the final image.
FROM ${BCI_BASE_IMAGE} AS tools-prep
RUN zypper --non-interactive refresh && \
    zypper --non-interactive install -y --no-recommends findutils && \
    mkdir -p /tmp/tools && \
    zypper --non-interactive install --download-only --force -y --no-recommends \
        sed \
        gawk \
        grep \
        findutils \
        which && \
    find /var/cache/zypp/packages/ -name '*.rpm' -exec cp -t /tmp/tools {} + 2>/dev/null || true

FROM gcr.io/viewo-g/dl-python:python3.13-bci-v1

ENV DL_PYTHON_EXECUTABLE=/usr/bin/python3.13
ENV PIP_NO_CACHE_DIR=1
ENV HOME=/tmp
ENV PATH="/tmp/.local/bin:${PATH}"
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Use Dell Artifactory PyPI mirror (avoids corporate proxy SSL interception)
ARG PIP_INDEX_URL=https://artifacts.dell.com/artifactory/api/pypi/python/simple
ARG PIP_TRUSTED_HOST=artifacts.dell.com
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ENV PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST}

# SUSE BCI bci-minimal has zypper removed. The agent runner script needs sed/awk/grep
# and other shell utilities that are not in the minimal base image, so we install
# their RPMs (downloaded in the tools-prep stage) with rpm before running pip.

# Install shell utilities required by the FaaS agent runner script.
COPY --from=tools-prep /tmp/tools/ /tmp/tools/
RUN set -eu && \
    if ls /tmp/tools/*.rpm 1>/dev/null 2>&1; then \
        rpm -Uvh --replacepkgs /tmp/tools/*.rpm; \
    else \
        echo "INFO: no utility RPMs to install"; \
    fi && \
    rm -rf /tmp/tools && \
    for tool in sed awk grep xargs find which; do \
        command -v "$tool" >/dev/null || { echo "missing: $tool"; exit 1; }; \
    done

# Upgrade pip and wheel to CVE-patched versions before installing anything else.
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir --upgrade \
    'pip>=26.1.2' \
    'wheel>=0.46.2'

# All Python packages in one layer — lets pip resolve the full dependency graph once.
# dtlpy pins attrs<25, validators<=0.18.2, fuzzyfinder<=2.1, webvtt-py==0.4.3
# so those are omitted here to avoid install-then-downgrade waste.
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir \
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

# Make /tmp accessible: existing files (chmod) + future files (ACL is not available
# in bci-minimal because setfacl/acl is not installed, but 777 suffices for runner needs)
RUN chmod -R 777 /tmp && \
    chmod 1777 /tmp

# Remove test private keys/certs shipped by future and tornado packages (Twistlock flag)
RUN find /usr/lib/python3.13/site-packages/future/backports/test -name '*.pem' -delete 2>/dev/null; \
    find /usr/lib/python3.13/site-packages/tornado/test -name '*.key' -delete 2>/dev/null; \
    find /usr/local/lib/python3.13/site-packages/future/backports/test -name '*.pem' -delete 2>/dev/null; \
    find /usr/local/lib/python3.13/site-packages/tornado/test -name '*.key' -delete 2>/dev/null; \
    true

# Dell Artifactory mirror is only reachable at build time. Reset pip to public PyPI
# so the FaaS agent's runtime installs can resolve dependencies from the internet.
ENV PIP_INDEX_URL=https://pypi.org/simple
ENV PIP_TRUSTED_HOST=pypi.org

# CIS 4.1: default non-root user (runner overrides via securityContext.runAsUser)
USER 1000

# docker build --platform linux/amd64 --pull --no-cache -f 'dockerfiles/cpu/python3.13/cpu.python3.13.full.bci.Dockerfile' -t 'cpu-python3.13-full-bci:latest' .
# docker tag cpu-python3.13-full-bci:latest hub.dataloop.ai/dtlpy-runner-images/cpu:python3.13_full_bci
# docker push hub.dataloop.ai/dtlpy-runner-images/cpu:python3.13_full_bci
