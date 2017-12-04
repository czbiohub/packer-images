#!/bin/bash

# download and install
wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O /tmp/anaconda.sh
bash /tmp/anaconda.sh -b -p $HOME/anaconda

export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' >> ~/.bashrc # add to bashrc for future use
hash -r

# some configuration to make it easy to install things
conda config --set always_yes yes --set changeps1 no
conda update -q conda

# add channels to look for packages
conda config --add channels r # for backward compatibility with old r packages
conda config --add channels defaults
conda config --add channels conda-forge # additional common tools
conda config --add channels bioconda # useful bioinformatics

# display info
conda info -a

exit 0
