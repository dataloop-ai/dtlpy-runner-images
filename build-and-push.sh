#!/usr/bin/env bash
# Build and push all dtlpy-runner-images to hub.dataloop.ai
# Usage:
#   ./build-and-push.sh              # build and push all images
#   ./build-and-push.sh --build-only # build without pushing
#   ./build-and-push.sh --no-cache   # build without Docker layer cache
#
# Prerequisites: docker login hub.dataloop.ai

set -euo pipefail

REGISTRY="hub.dataloop.ai/dtlpy-runner-images"
PUSH=true
CACHE_FLAG=""

for arg in "$@"; do
  case $arg in
    --build-only) PUSH=false ;;
    --no-cache)   CACHE_FLAG="--no-cache" ;;
  esac
done

build_and_push() {
  local dockerfile="$1"
  local tag="$2"
  echo ""
  echo "==> Building $tag"
  docker build --platform linux/amd64 --pull $CACHE_FLAG \
    -f "$dockerfile" \
    -t "$REGISTRY/$tag" \
    .
  if [ "$PUSH" = true ]; then
    echo "==> Pushing $tag"
    docker push "$REGISTRY/$tag"
  fi
}

# ── CPU base images (must build before pytorch2/tf2.16) ──────────────────────
build_and_push dockerfiles/cpu/python3.10/cpu.python3.10.opencv.Dockerfile  "cpu:python3.10_opencv"
build_and_push dockerfiles/cpu/python3.11/cpu.python3.11.opencv.Dockerfile  "cpu:python3.11_opencv"
build_and_push dockerfiles/cpu/python3.12/cpu.python3.12.opencv.Dockerfile  "cpu:python3.12_opencv"

# ── CPU derivative images ─────────────────────────────────────────────────────
build_and_push dockerfiles/cpu/python3.10/cpu.python3.10.pytorch2.Dockerfile  "cpu:python3.10_pytorch2"
build_and_push dockerfiles/cpu/python3.11/cpu.python3.11.pytorch2.Dockerfile  "cpu:python3.11_pytorch2"
build_and_push dockerfiles/cpu/python3.12/cpu.python3.12.pytorch2.Dockerfile  "cpu:python3.12_pytorch2"

build_and_push dockerfiles/cpu/python3.10/cpu.python3.10.tf2.16.Dockerfile  "cpu:python3.10_tf2.16"
build_and_push dockerfiles/cpu/python3.11/cpu.python3.11.tf2.16.Dockerfile  "cpu:python3.11_tf2.16"
build_and_push dockerfiles/cpu/python3.12/cpu.python3.12.tf2.16.Dockerfile  "cpu:python3.12_tf2.16"

# ── GPU base images (must build before pytorch2) ──────────────────────────────
build_and_push dockerfiles/gpu/python3.10/gpu.python3.10.cuda11.8.opencv.Dockerfile  "gpu:python3.10_cuda11.8_opencv"
build_and_push dockerfiles/gpu/python3.11/gpu.python3.11.cuda11.8.opencv.Dockerfile  "gpu:python3.11_cuda11.8_opencv"
build_and_push dockerfiles/gpu/python3.12/gpu.python3.12.cuda11.8.opencv.Dockerfile  "gpu:python3.12_cuda11.8_opencv"

# ── GPU derivative images ─────────────────────────────────────────────────────
build_and_push dockerfiles/gpu/python3.10/gpu.python3.10.cuda11.8.pytorch2.Dockerfile  "gpu:python3.10_cuda11.8_pytorch2"
build_and_push dockerfiles/gpu/python3.11/gpu.python3.11.cuda11.8.pytorch2.Dockerfile  "gpu:python3.11_cuda11.8_pytorch2"
build_and_push dockerfiles/gpu/python3.12/gpu.python3.12.cuda11.8.pytorch2.Dockerfile  "gpu:python3.12_cuda11.8_pytorch2"

echo ""
echo "Done. All images built$([ "$PUSH" = true ] && echo ' and pushed' || echo ' (push skipped)')."
