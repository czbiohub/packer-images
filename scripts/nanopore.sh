#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

conda install virtualenv
conda install biopython

echo "setting up albacore"

wget -P /tmp/ https://mirror.oxfordnanoportal.com/software/analysis/ont_albacore-2.1.3-cp36-cp36m-manylinux1_x86_64.whl

conda create -n albacore python=3
source activate albacore
pip install /tmp/ont_albacore-2.1.3-cp36-cp36m-manylinux1_x86_64.whl 
source deactivate

echo "done with albacore setup"

echo "installing pomoxis dependencies"

yes | sudo apt-get install libz-dev
yes | sudo apt-get install libncurses5-dev
yes | sudo apt-get install libhdf5-dev
yes | sudo apt-get install libblas*

echo "setting up pomoxis"

git clone --recursive https://github.com/nanoporetech/pomoxis
cd pomoxis/

echo "starting make"


CFLAGS="-I/usr/include/hdf5/serial" CPPFLAGS="-I/usr/include/hdf5/serial" make V=1 install

echo "done with pomoxis setup"

exit 0
