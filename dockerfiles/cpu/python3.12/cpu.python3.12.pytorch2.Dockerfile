FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_opencv

USER 1000
ENV HOME=/tmp

RUN /usr/local/bin/python3.12 -m pip install --upgrade pip
RUN /usr/local/bin/python3.12 -m pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_pytorch2