FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir tensorflow==2.16.1


# docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_tf2.16