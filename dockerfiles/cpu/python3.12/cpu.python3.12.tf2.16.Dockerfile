FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_opencv

RUN /usr/local/bin/python3.12 -m pip install --upgrade pip
RUN /usr/local/bin/python3.12 -m pip install --no-cache-dir tensorflow==2.16.1


# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_tf2.16