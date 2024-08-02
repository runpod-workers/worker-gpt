<div align="center">

<h1>RunPod Transformer Handler</h1>

[![CI | Test Worker](https://github.com/runpod-workers/worker-template/actions/workflows/CI-test_worker.yml/badge.svg)](https://github.com/runpod-workers/worker-template/actions/workflows/CI-test_worker.yml)
&nbsp;
[![Docker Image](https://github.com/runpod-workers/worker-template/actions/workflows/CD-docker_dev.yml/badge.svg)](https://github.com/runpod-workers/worker-template/actions/workflows/CD-docker_dev.yml)

🚀 | A serverless handler for running various transformer-based language models on RunPod's infrastructure.
</div>

## 📖 | Overview

This project provides a flexible and scalable solution for deploying transformer-based language models on RunPod's serverless infrastructure, allowing for efficient text generation tasks.

### Features

1. Supports multiple language models:
   - GPT-Neo 1.3B
   - GPT-Neo 2.7B
   - GPT-NeoX 20B
   - Pygmalion 6B
   - GPT-J 6B

2. Uses RunPod's serverless infrastructure for efficient deployment and scaling.

3. Provides a flexible input schema for text generation, including options for:
   - Prompt
   - Sampling method
   - Maximum length
   - Temperature

4. Utilizes GPU acceleration when available.

5. Includes a separate script for downloading and caching models locally.

## 🚀 | Getting Started

1. Clone this repository.
2. Add your code to the `src` directory.
3. Update the `handler.py` file to load models and process requests.
4. Add any dependencies to the `requirements.txt` file.
5. Add any other build time scripts to the `builder` directory, for example, downloading models.
6. Update the `Dockerfile` to include any additional dependencies.

### Usage

1. The main script (`handler.py`) sets up a RunPod serverless handler that generates text based on the input provided.

2. The model fetcher script (`model_fetcher.py`) can be used to download and cache models locally before running the handler.

3. To use a specific model, provide the `--model_name` argument when running the scripts. Supported model names are:
   - `gpt-neo-1.3B`
   - `gpt-neo-2.7B`
   - `gpt-neox-20b`
   - `pygmalion-6b`
   - `gpt-j-6b`

4. The handler accepts JSON input with the following schema:
   ```json
   {
     "prompt": "Your text prompt here",
     "do_sample": true,
     "max_length": 100,
     "temperature": 0.9
   }
   ```

5. The handler returns the generated text as output.

## 🛠 | Development

### CI/CD

This repository is set up to automatically build and push a docker image to the GitHub Container Registry. You will need to add the following to the GitHub Secrets for this repository to enable this functionality:

- `DOCKERHUB_USERNAME` | Your DockerHub username for logging in.
- `DOCKERHUB_TOKEN` | Your DockerHub token for logging in.
- `DOCKERHUB_REPO` | The name of the repository you want to push to.
- `DOCKERHUB_IMG` | The name of the image you want to push to.

The `CD-docker_dev.yml` file will build the image and push it to the `dev` tag, while the `CD-docker_release.yml` file will build the image on releases and tag it with the release version.

The `CI-test_worker.yml` file will test the worker using the input provided by the `--test_input` argument when calling the file containing your handler. Be sure to update this workflow to install any dependencies you need to run your tests.

## 📝 | Best Practices

1. Models should be part of your docker image. This can be accomplished by either copying them into the image or downloading them during the build process.

2. If using the input validation utility from the runpod python package, create a `schemas` python file where you can define the schemas, then import that file into your `handler.py` file.

3. Ensure all necessary dependencies are listed in the `requirements.txt` file.

4. Use GPU acceleration when available for better performance.

5. Keep the handler code modular and easy to maintain, separating concerns where possible.
