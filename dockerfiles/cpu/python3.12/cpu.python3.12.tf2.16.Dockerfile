FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_cuda11.8_opencv

RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip3 --no-cache-dir install tensorflow==2.16.1


# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_tf2.16