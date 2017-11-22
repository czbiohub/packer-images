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

mkdir $HOME/bin

sudo cp $progdir/mageck $HOME/bin
sudo cp $progdir/mageckGSEA $HOME/bin
sudo cp $progdir/RRA $HOME/bin

sudo rm -r /home/ubuntu/MAGeCKlatest
sudo rm /home/ubuntu/MAGeCKlatest.tar.gz

echo "finished with MAGeCK"

exit 0
