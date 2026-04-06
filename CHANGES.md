# Security Update Changelog — 2026-03-25 (rev 2026-04-05)

## Overview

Security update pass across all 15 Dockerfiles.
Driven by OX Security scan, Black Duck scan (April 5), Twistlock cross-reference (58+ OS CVEs), and manual Dockerfile audit.

**Removed from base images (should come from SDK/app layer):**
- `diskcache` — removed entirely. CVE-2025-69872 (CVSS 9.8, RCE via pickle deserialization) affects all versions through 5.6.3. Installed at runtime by the dtlpy SDK, not needed in base images.
- `code-server` — removed .deb install and `code-server-installation.sh` invocation from CPU images. Reduces attack surface and image size.

**Removed from py3.11/py3.12 images:**
- `imgaug==0.4.0` — abandoned since 2020, incompatible with numpy 2.x (uses removed `np.bool`/`np.int`/`np.float` aliases). Kept only on py3.10 (numpy <2). Apps needing image augmentation should install `albumentations` directly.

**Skipped (P3 — breaking API changes, require coordinated SDK update):**
- `PyJWT <=1.7.1` on GPU images — stays; `jwt.decode()` signature changed in 2.x. **Known CVEs: CVE-2022-29217 (algorithm confusion, CVSS 7.4)**
- `pandas >=0.24.2,<1.4` on CPU py3.10 — stays; `DataFrame.append()` removed in 2.x. **Known CVEs: CVE-2023-42798 (arbitrary code exec via read_pickle)**

---

## Files Changed

### CPU OpenCV Base Images (all 3)
`cpu.python3.10.opencv` · `cpu.python3.11.opencv` · `cpu.python3.12.opencv`

| What | Before | After |
|---|---|---|
| `code-server` | Installed via `.deb` + `code-server-installation.sh` | **Removed** — reduces attack surface and image size |
| `diskcache` | `==5.2.1` | **Removed** — CVE-2025-69872 (CVSS 9.8); comes from SDK at runtime |
| OS packages | `apt-get update` + `apt-get install` | Added `apt-get upgrade -y` + `apt-get clean` + `rm -rf /var/lib/apt/lists/*` (resolves 58 OS CVEs) |
| Build tools | `pip install --upgrade pip` only | Added `pip>=26.0`, `setuptools>=82.0`, `wheel>=0.46.2` (CVE-2024-6345, CVE-2025-47273, CVE-2026-24049, CVE-2025-8869) |
| `certifi` | `>=2020.12.5,<2021.10.8` | `>=2026.2.25` |
| `requests` | `>=2.21.0,<2.26.0` | `>=2.32.0,<3` (CVE-2023-32681) |
| `jinja2` | `>=2.11.3,<3.0.2` | `>=3.1.6,<4` (sandbox escape CVEs) |
| `tornado` | `==6.0.2` | `==6.5.5` |
| `aiohttp` | `>=3.6.2,<4.0.0` | `>=3.13.0,<4` |
| `requests-toolbelt` | `==0.9.1` | `==1.0.0` |
| `redis` | `==4.1.3` (EOL 4.x) | `>=5.0.0,<6` |
| `websocket-client` | `==1.2.3` | `==1.9.0` |
| `psutil` | `==5.6.7` | `>=7.0.0` |
| `pika` | `==1.0.1` | `==1.3.2` |
| `imgaug` | `==0.2.9` | `==0.4.0` (py3.10 only; removed from py3.11/3.12 — numpy 2.x incompatible) |
| `webvtt-py` | `==0.4.3` | `==0.5.1` |
| `tabulate` | `==0.8.9` | `==0.10.0` |
| `PyJWT` (CPU only) | `>=2.4` | `>=2.12.0` |
| `tqdm` | `>=4.32.2,<4.62.3` | `>=4.67.0` |
| `attrs` | `<20.0.0` | `>=26.0.0` |
| `prompt_toolkit` | `>=2.0.9,<3.0.20` | `>=3.0.50` |
| `fuzzyfinder` | `<=2.1.0` | `<=2.3.0` |
| `dictdiffer` | `>=0.8.1,<0.9.0` | `>=0.9.0` |
| `validators` | `<=0.18.2` | `>=0.35.0` |
| `pathspec` | `>=0.8.1,<0.10` | `>=1.0.0` |
| `filelock` | `>=3.0.12,<3.5.0` | `>=3.25.0` |
| `Pillow` | `>=11.0.0` | `>=12.0.0` |
| `pydantic` | unpinned | `>=2.12.0,<3` |
| `py3nvml` | unpinned | `==0.2.7` |

**Per-image specifics:**

| Image | Package | Before | After |
|---|---|---|---|
| py3.10 | `numpy` | `<1.22,>=1.16.2` | `>=1.26.0,<2` |
| py3.10 | `pandas` | `>=0.24.2,<1.4` | **unchanged** (breaking) |
| py3.11 | `numpy` | `>=2.0,<3` | `>=2.4.0,<3` |
| py3.12 | `numpy` | `>=2.0,<3` | `>=2.4.0,<3` |

---

### GPU OpenCV Base Images (all 3)
`gpu.python3.10.cuda11.8.opencv` · `gpu.python3.11.cuda11.8.opencv` · `gpu.python3.12.cuda11.8.opencv`

| What | Before | After |
|---|---|---|
| `MAINTAINER` directive | `MAINTAINER Dataloop Team ...` | `LABEL maintainer="Dataloop Team ..."` |
| OS packages | `apt-get update && apt-get install` | Added `apt-get upgrade -y` + `apt-get clean` + `rm -rf /var/lib/apt/lists/*` |
| Build tools | `pip install --upgrade pip` + separate `pip install --upgrade setuptools` | Combined; added `pip>=26.0`, `setuptools>=82.0`, `wheel>=0.46.2` |
| `PyJWT` | `<=1.7.1` | **unchanged** (breaking — 1.x→2.x API change) |
| `opencv_python` (py3.10 only) | `opencv_python` (full, with GUI) | `opencv-python-headless>=4.13.0` |
| `Cython` | `>=0.29` | `>=3.0.0` |
| `scikit-learn` | unpinned | `>=1.8.0` |
| `pandas` | unpinned | `>=2.2.0,<3` |
| `tabulate` | unpinned | `==0.10.0` |
| `imgaug` | unpinned | `==0.4.0` (py3.10 only; removed from py3.11/3.12 — numpy 2.x incompatible) |
| `psutil` | unpinned | `>=7.0.0` |
| All shared packages | same as CPU table above | same as CPU table above |

**Per-image specifics:**

| Image | Package | Before | After |
|---|---|---|---|
| py3.10 | `numpy` | `<1.22,>=1.16.2` | `>=1.26.0,<2` |
| py3.11 | `numpy` | `>=2.0,<3` | `>=2.4.0,<3` |
| py3.11 | `opencv` | `>=4.1.2` | `>=4.13.0` |
| py3.12 | `numpy` | `>=2.0,<3` | `>=2.4.0,<3` |
| py3.12 | `opencv` | `>=4.1.2` | `>=4.13.0` |

---

### PyTorch2 Images (all 6)
`cpu.python3.10/11/12.pytorch2` · `gpu.python3.10/11/12.cuda11.8.pytorch2`

| What | Before | After |
|---|---|---|
| `pip install` cache | no `--no-cache-dir` on torch install | Added `--no-cache-dir` |
| `USER 1000` (cpu.python3.12 only) | `USER 1000` + `ENV HOME=/tmp` | Removed (contradicts README guidelines and all other images) |

---

### TensorFlow 2.16 Images (all 3 CPU)
`cpu.python3.10/11/12.tf2.16`

| What | Before | After |
|---|---|---|
| `tensorflow` | `==2.16.1` | `==2.18.0` |

---

### Additional hardening (rev 2026-04-05)

| What | Details |
|---|---|
| `opencv-python-headless` | Aligned CPU images to `>=4.13.0` (was `>=4.1.2`), matching GPU images |
| `py3nvml` | Pinned to `==0.2.7` on all CPU images (was unpinned on py3.11/3.12) |
| `pydantic` | Added upper bound `<3` to prevent breaking major version auto-upgrade |
| `.dockerignore` | Added to exclude `.git`, `*.md`, and build scripts from Docker context |
| Quote style | Standardized to single quotes across all Dockerfiles |
