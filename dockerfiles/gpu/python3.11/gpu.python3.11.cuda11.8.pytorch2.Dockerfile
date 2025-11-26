FROM hub.dataloop.ai/dtlpy-runner-images/gpu:python3.11_cuda11.8_opencv

RUN /usr/bin/python3.11 -m pip install --upgrade pip
RUN /usr/bin/python3.11 -m pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/gpu:python3.11_cuda11.8_pytorch2