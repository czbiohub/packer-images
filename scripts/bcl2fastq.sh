#!/bin/bash

# download and install

# for some reason this build demands lots of naps
for try in {1..100}; do
    if [[ $try -gt 1 ]]
    then
        echo "sleeping 10 sec"
        sleep 10
    fi
    sudo dpkg --configure -a || continue
    break
done

yes | sudo apt-get install alien

for try in {1..100}; do
    if [[ $try -gt 1 ]]
    then
        echo "sleeping 10 sec"
        sleep 10
    fi
    sudo dpkg --configure -a || continue
    break
done

yes | sudo apt-get install unzip

wget --no-verbose -P /tmp/ https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-linux-x86-64.zip

unzip /tmp/bcl2fastq2-v2-20-0-linux-x86-64.zip -d /tmp/

sudo alien -i /tmp/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm

bcl2fastq --version

# note: update with recent key from their website
# https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
wget --no-verbose -O /tmp/cellranger-2.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-2.1.0.tar.gz
tar -xzf /tmp/cellranger-2.1.0.tar.gz -C /tmp
sudo mv /tmp/cellranger-2.1.0/* /usr/local/bin/
