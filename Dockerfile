FROM runpod/pytorch:3.10-2.0.0-117

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /src

ARG MODEL_NAME
ENV MODEL_NAME=${MODEL_NAME}

# Install System Dependencies
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends\
    wget\
    bash\
    openssh-server &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

RUN apt-get update && apt-get install -y --no-install-recommends
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install python3.8 -y
RUN apt-get install python3-pip -y
RUN apt-get install python3.8-distutils -y

RUN apt-get install python3.8-dev -y
RUN apt-get install python3.8-venv -y
RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH

# Install Python dependencies (Worker Template)
COPY builder/requirements.txt /requirements.txt
RUN python3.8 -m pip install --upgrade pip && \
    python3.8 -m pip install -r /requirements.txt && \
    rm /requirements.txt

COPY builder/model_fetcher.py /src/model_fetcher.py
RUN python3.8 model_fetcher.py --model_name=${MODEL_NAME}
RUN rm model_fetcher.py

# Add src files (Worker Template)
ADD src .

CMD python3.8 -u runpod_infer.py --model_name=${MODEL_NAME}
