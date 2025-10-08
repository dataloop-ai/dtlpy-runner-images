FROM hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_opencv
USER 1000
ENV HOME=/tmp
RUN python3 -m pip install --upgrade pip
RUN pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_pytorch2