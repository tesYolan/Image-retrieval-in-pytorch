FROM ubuntu:18.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        python3.6 \
        python3.6-dev \
        python3-pip \
        python-setuptools \
        cmake \
        wget \
        curl \
        libsm6 \
        libxext6 \ 
        libxrender-dev


RUN python3.6 -m pip install -U pip
RUN python3.6 -m pip install --upgrade setuptools
COPY requirements.txt /tmp

WORKDIR /tmp

RUN python3.6 -m pip install -r requirements.txt

COPY . /image-retrieval-in-pytorch

WORKDIR /image-retrieval-in-pytorch

VOLUME /image-retrieval-in-pytorch/data/classed_data

EXPOSE 8003
EXPOSE 8004


RUN cd Service && python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. image_retrival.proto

RUN ./install.sh

CMD ["python3.6", "run-snet-service.py","--daemon-config-path-kovan","snet.config.example.kovan.json","--daemon-config-path-ropsten","snet.config.example.ropsten.json"]
