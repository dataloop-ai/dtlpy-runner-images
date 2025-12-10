FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv

RUN ${DL_PYTHON_EXECUTABLE} -m pip install --upgrade pip
RUN ${DL_PYTHON_EXECUTABLE} -m pip install --no-cache-dir tensorflow==2.16.1


#docker pull hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_tf2.16