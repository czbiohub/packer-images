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

wget -P /tmp/ https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-linux-x86-64.zip

unzip /tmp/bcl2fastq2-v2-20-0-linux-x86-64.zip -d /tmp/

sudo alien -i /tmp/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm

bcl2fastq --version
