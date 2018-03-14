TODO: change, deprecated

# Automatization of smart contract security assessment

## File overview

```
Dockerfile 	       = used to build the docker container
autoanalysis.sh    = Bash script for automatic analysis, uploaded in the docker container
docker_analysis.sh = Bash script to initiate the analysis from the host
```

## Docker container setup

All Docker dependencies are installed via Dockerfile. To setup the Docker container, position yourself in the folder where the Dockerfile is and execute:

`$ docker build [repository]:[tag] .`

This will build an image which contains tools for analysing smart contracts. Afterwards you can run it with:

`$ docker run -it [container_name]`

Image is based on `ubuntu` and contains the following:
- Dependencies:
  - sudo
  - git
  - python2
  - python3
  - python2-pip
  - python3-pip
  - libssl-dev
  - apt-utils
  - curl
  - software-properties-common
  - zip
  - nodejs
  - solc
  - evm
  - truffle
- Assessment tools:
  - manticore
  - mythril
  - oyente
- Linters:
  - solcheck
  - solium
  - solhint

## Automatic analysis from the host

_NOTE: Still in testing phase. Some parts of it can break due to incompatible solidity versions, etc. Keep in mind that at this phase contracts are provided via GitHub URL_

You can analyse contracts manually from inside the docker image or do it automatically with provided `autoanalysis.sh` and `docker_analysis.sh` scripts. To run the automatic analysis, both scripts need to be in the same folder:

`./docker_analysis.sh [container_name] [project_name] [github_url]`

This will initiate the upload of `autoanalyse.sh` into the container and execute it from inside the container. All the reports are zipped and pulled from the docker container back to the host. Ideally, user only needs to run the command and wait for the zip to turn up inside the folder.

**Happy testing.**
