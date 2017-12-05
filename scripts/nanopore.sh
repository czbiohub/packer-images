#!/bin/bash

export PATH=$HOME/anaconda/bin:$PATH

git clone --recursive https://github.com/nanoporetech/pomoxis

conda install virtualenv

cd pomoxis/

yes | sudo apt-get install libz-dev
yes | sudo apt-get install libncurses5-dev
yes | sudo apt-get install libhdf5-dev
yes | sudo apt-get install libblas*

CFLAGS="-I/usr/include/hdf5/serial" CPPFLAGS="-I/usr/include/hdf5/serial" make install

conda install biopython

wget -P /tmp/ https://mirror.oxfordnanoportal.com/software/analysis/ont_albacore-2.1.3-cp36-cp36m-manylinux1_x86_64.whl

conda create -n albacore python=3
source activate albacore
pip install /tmp/ont_albacore-2.1.3-cp36-cp36m-manylinux1_x86_64.whl 
source deactivate

exit 0
