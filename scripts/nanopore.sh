#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

echo "setting up guppy"

yes | sudo apt-get install wget lsb-release
export PLATFORM=$(lsb_release -cs)
wget -O- https://mirror.oxfordnanoportal.com/apt/ont-repo.pub | sudo apt-key add -
echo "deb http://mirror.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" | sudo tee /etc/apt/sources.list.d/nanoporetech.sources.list
yes | sudo apt-get update
yes | sudo apt-get install ont-guppy-cpu

df -h

echo "setting up pomoxis"

conda install pomoxis -c bioconda

exit 0
