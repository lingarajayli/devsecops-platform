FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y curl ca-certificates bash && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash

ENTRYPOINT ["kubescape"]