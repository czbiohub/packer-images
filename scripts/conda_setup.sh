#!/bin/bash -x

# some configuration to make it easy to install things
conda config --set always_yes yes --set changeps1 no
conda update -q conda

# add channels to look for packages
conda config --add channels r # for backward compatibility with old r packages
conda config --add channels defaults
conda config --add channels conda-forge # additional common tools
conda config --add channels bioconda # useful bioinformatics

conda install -n root _license

# display info
conda info -a

exit 0
