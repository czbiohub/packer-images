#!/bin/bash
yes | sudo apt-get install libz-dev
yes | sudo apt-get install libtbb-dev

wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.3.1/bowtie2-2.3.3.1-source.zip
unzip bowtie2-2.3.3.1-source.zip
cd bowtie2-2.3.3.1/
echo "building..."
make

echo "done building, moving binaries"
sudo cp bowtie2{,-align-s,-align-l,-build,-build-s,-build-l,-inspect,-inspect-s,-inspect-l} /usr/local/bin/
cd $HOME

echo "removing source directory"
rm bowtie2-2.3.3.1-source.zip
rm -rf bowtie2-2.3.3.1
echo "finished"

exit 0
