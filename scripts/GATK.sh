#!/bin/bash

#JAVA
yes | sudo apt-get update
yes | sudo apt-get install default-jre


#GATK
wget -O GATKlatest.tar.bz2 https://software.broadinstitute.org/gatk/download/auth?package=GATK

mkdir GATKlatest
tar xvjf GATKlatest.tar.bz2 -C /home/ubuntu/GATKlatest/
cd GATKlatest

version=$(ls)

cd $version

GATKpath=$(pwd)
GATKfile=$(ls)
	

sudo cp $GATKpath/$GATKfile /usr/local/bin

sudo rm -r /home/ubuntu/GATKlatest
sudo rm /home/ubuntu/GATKlatest.tar.bz2

echo "finished with GATK"

exit 0
