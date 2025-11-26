FROM hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_opencv

RUN /usr/bin/python3.10 -m pip install --upgrade pip
RUN /usr/bin/python3.10 -m pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_pytorch2