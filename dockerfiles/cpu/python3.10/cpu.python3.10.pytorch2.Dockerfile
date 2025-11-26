FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv

RUN /usr/local/bin/python3.10 -m pip install --upgrade pip
RUN /usr/local/bin/python3.10 -m pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_pytorch2
