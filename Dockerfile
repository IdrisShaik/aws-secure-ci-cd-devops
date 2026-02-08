FROM jenkins/jenkins:lts-jdk17

USER root

# Install base dependencies + Docker
RUN apt-get update && \
    apt-get install -y \
      curl \
      unzip \
      ca-certificates \
      docker.io && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2 (ARM64)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install kubectl (ARM64)
RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Allow Jenkins user to run docker
RUN usermod -aG docker jenkins

USER jenkins
