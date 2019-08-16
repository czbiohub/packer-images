#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get -y update

DEBIAN_FRONTEND=noninteractive sudo apt-get -y install build-essential
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install awscli unzip

exit 0
