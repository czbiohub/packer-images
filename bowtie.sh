#!/bin/bash
echo "sleeping 30 sec"; sleep 30
for try in {1..100}; do if [[ $try -gt 1 ]]; then echo "sleeping 10 sec"; sleep 10; fi; sudo dpkg --configure -a || continue; break; done
sudo apt-get -f install
yes | sudo apt-get install make
yes | sudo apt-get install g++
yes | sudo apt-get install libz-dev
yes | sudo apt-get install libtbb-dev
wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.3.1/bowtie2-2.3.3.1-source.zip
unzip bowtie2-2.3.3.1-source.zip
cd bowtie2-2.3.3.1/
make && echo "done building"
exit 0
