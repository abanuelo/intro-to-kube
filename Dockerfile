
FROM --platform=linux/amd64 ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# installing docker
RUN     apt-get -y update
RUN     apt-get -y install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

RUN     mkdir -p /etc/apt/keyrings
RUN     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN     echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN     apt-get -y update
RUN     apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# installing kubectl
#RUN     apt-get install -y ca-certificates curl
ARG KUBECTL_VERSION=v1.22.2

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube

# installing other dependencies
RUN     apt-get install conntrack

# installing minikube
RUN     curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
        && chmod +x minikube

RUN     mkdir -p /usr/local/bin/
RUN     install minikube /usr/local/bin/

CMD     tail -F /dev/null
