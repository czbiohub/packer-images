#!/bin/bash
yes | sudo apt-get install libz-dev
yes | sudo apt-get install libtbb-dev
wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.3.1/bowtie2-2.3.3.1-source.zip
unzip bowtie2-2.3.3.1-source.zip
cd bowtie2-2.3.3.1/
make && echo "done building"
exit 0
