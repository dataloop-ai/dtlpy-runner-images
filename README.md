# Dataloop Agent Docker Images

This repository contains public Docker images that can be used for your applications in Dataloop, or as base images to build custom Docker images for Dataloop platform.

## Available Images

All images are hosted on `hub.dataloop.ai/dtlpy-runner-images/` and come pre-configured with the necessary dependencies for running applications on the Dataloop platform.

### CPU Images

#### Python 3.10

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_pytorch2`
- **TensorFlow 2.16**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_tf2.16`

#### Python 3.11

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_pytorch2`
- **TensorFlow 2.16**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.11_tf2.16`

#### Python 3.12

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_pytorch2`
- **TensorFlow 2.16**: `hub.dataloop.ai/dtlpy-runner-images/cpu:python3.12_tf2.16`

### GPU Images (CUDA 11.8)

#### Python 3.10

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.10_cuda11.8_pytorch2`

#### Python 3.11

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.11_cuda11.8_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.11_cuda11.8_pytorch2`

#### Python 3.12

- **OpenCV**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.12_cuda11.8_opencv`
- **PyTorch 2**: `hub.dataloop.ai/dtlpy-runner-images/gpu:python3.12_cuda11.8_pytorch2`

## Usage

### Option 1: Use in dataloop.json

You can use these images directly in your Dataloop application by specifying the image in your `dataloop.json` configuration file:

```json
{
  "name": "your-application-name",
  "displayName": "Your Application Display Name",
  "version": "0.1.0",
  "scope": "public",
  "description": "Your application description",
  "attributes": {
    "Provider": "YourName",
    "Category": "Model",
    "Computer Vision": "Object Detection"
  },
  "codebase": {
    "type": "git",
    "gitUrl": "https://github.com/your-org/your-repo.git",
    "gitTag": "0.1.0"
  },
  "components": {
    "computeConfigs": [
      {
        "name": "your-config-name",
        "runtime": {
          "podType": "regular-xs",
          "concurrency": 1,
          "runnerImage": "hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_pytorch2",
          "autoscaler": {
            "type": "rabbitmq",
            "minReplicas": 0,
            "maxReplicas": 1
          }
        }
      }
    ],
    "modules": [
      {
        "name": "your-module-name",
        "entryPoint": "model_adapter.py",
        "className": "YourModelAdapter",
        "computeConfig": "your-config-name",
        "description": "Your module description",
        "initInputs": [],
        "functions": [
          {
            "name": "predict_items",
            "input": [],
            "output": [],
            "displayName": "Predict Items",
            "displayIcon": "",
            "description": "Function to run predictions on items"
          }
        ]
      }
    ]
  }
}
```

Check out a real example in the [RF-DETR Adapter](https://github.com/dataloop-ai-apps/rf-detr-adapter) repository.

### Option 2: Build Custom Images

Use these images as base images to add your own dependencies and configurations:

```dockerfile
FROM hub.dataloop.ai/dtlpy-runner-images/cpu:python3.10_opencv

USER 1000
ENV HOME=/tmp

# Install your custom dependencies
RUN pip install --user your-package-name

# Add your application code
COPY your-app /app
```

Then build and push your custom image:

```bash
docker build -t your-registry/your-image:tag -f your.Dockerfile .
docker push your-registry/your-image:tag
```

> **Important:** Your Docker registry must be public so that Dataloop has access to pull the container image.

Finally, reference your custom image in the `dataloop.json` file:

```json
"runtime": {
  "podType": "regular-xs",
  "concurrency": 1,
  "runnerImage": "your-registry/your-image:tag"
}
```

## What's Included

All images come with:

- Pre-installed Python environment (3.10 or 3.11)
- Common data science and ML libraries (numpy, scipy, pandas, etc.)
- Dataloop platform dependencies
- Code-server with Python extension (CPU OpenCV base images)

Specific images include:

- **OpenCV images**: Computer vision libraries and dependencies
- **PyTorch images**: PyTorch, torchvision, and torchaudio
- **TensorFlow images**: TensorFlow framework
- **GPU images**: NVIDIA CUDA 11.8 and cuDNN support

## Support

For more information about using Docker images with Dataloop, please refer to the [Dataloop Documentation](https://dataloop.ai/docs/).
