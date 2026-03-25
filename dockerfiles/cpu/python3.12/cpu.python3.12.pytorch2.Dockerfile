FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_opencv

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir --user 'torch>=2.8.0' 'torchvision' 'torchaudio'

# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_pytorch2
