FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv

USER 1000
ENV HOME=/tmp

RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_pytorch2