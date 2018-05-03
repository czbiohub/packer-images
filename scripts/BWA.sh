#!/bin/bash

wget -O bwalatest.tar.bz2 https://sourceforge.net/projects/bio-bwa/files/latest/download

mkdir bwalatest
tar xvjf bwalatest.tar.bz2 -C /home/ubuntu/bwalatest/
cd bwalatest
version=$(ls)

cd $version
make
currdir=$(pwd)

sudo cp $currdir/bwa /usr/local/bin


sudo rm /home/ubuntu/bwalatest.tar.bz2
sudo rm -r /home/ubuntu/bwalatest

echo "finished with bwa"

exit 0




