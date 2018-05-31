FROM ubuntu:trusty

# Replace shell with bash so we can source files
RUN rm /bin/sh && \
    ln -s /bin/bash /bin/sh

# Install utilities
RUN apt-get -y update && \
    apt-get -y install \
        git-core \
        curl \
        g++-4.8 \
        nasm \
        python \
        build-essential

# Env variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.14.0
ENV CXX g++-4.8
ENV PATH ~/.yarn/bin:~/google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1

# Install Google Cloud utils, the folder is created by travis since it's being cached
RUN curl https://sdk.cloud.google.com | bash > /dev/null

# Auth with Google Cloud utils
RUN source ~/google-cloud-sdk/path.bash.inc

# Install nvm and node
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
RUN source $NVM_DIR/nvm.sh && \
    nvm install v$NODE_VERSION && \
    nvm alias default v$NODE_VERSION && \
    nvm use default

# Setup Node path
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.6.0

# Copy code
COPY . /app/
RUN cd /app

# Install dependencies
RUN yarn --frozen-lockfile
