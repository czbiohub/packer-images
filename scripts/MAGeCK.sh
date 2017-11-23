#!/bin/bash

#MAGeCK

wget -O MAGeCKlatest.tar.gz https://sourceforge.net/projects/mageck/files/latest/download



mkdir MAGeCKlatest
tar -xvzf MAGeCKlatest.tar.gz -C /home/ubuntu/MAGeCKlatest

cd MAGeCKlatest
version=$(ls)
cd $version


sudo python setup.py install
cd bin

progdir=$(pwd)

sudo cp $progdir/mageck /usr/local/bin
sudo cp $progdir/mageckGSEA /usr/local/bin
sudo cp $progdir/RRA /usr/local/bin

sudo rm -r /home/ubuntu/MAGeCKlatest
sudo rm /home/ubuntu/MAGeCKlatest.tar.gz

echo "finished with MAGeCK"

exit 0
