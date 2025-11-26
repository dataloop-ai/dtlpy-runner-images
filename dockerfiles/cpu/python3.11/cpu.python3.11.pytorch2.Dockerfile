FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv

RUN /usr/local/bin/python3.11 -m pip install --upgrade pip
RUN /usr/local/bin/python3.11 -m pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_pytorch2