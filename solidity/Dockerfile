FROM ubuntu
MAINTAINER foi-oss version: 1.0

# Update and create workspace
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y apt-utils sudo git python python3 python-pip python3-pip libssl-dev curl software-properties-common zip wget
RUN pip2 install --upgrade pip
RUN pip3 install --upgrade pip
RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install solidity and evm
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install -y solc evm

# Install tools
RUN pip2 install manticore
RUN pip3 install mythril
RUN pip2 install oyente
# Note that SmartCheck is web based and cannot be installed

# Install truffle and linters
RUN npm install -g ajv@6.0.0 ajv@6.2.0 ajv-keywords
RUN npm install -g truffle
RUN cd /usr/lib/node_modules/truffle && npm install solc@0.4.18 && npm install solc@0.4.17
# Reinstall ajv to resolve dependency warnings
RUN npm install -g ajv@6.0.0 ajv@6.2.0 ajv-keywords solcheck solium solhint
RUN apt-get update && apt-get upgrade -y

# Pull solc versions
RUN cd /
RUN mkdir solcv
RUN cd solcv && wget -O solc18.zip https://github.com/ethereum/solidity/releases/download/v0.4.18/solidity-ubuntu-trusty.zip && wget -O solc17.zip https://github.com/ethereum/solidity/releases/download/v0.4.17/solidity-ubuntu-trusty.zip && cp /usr/bin/solc solc19
