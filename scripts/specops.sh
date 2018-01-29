#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

echo "install blast, star, bowtie2, rapsearch"
conda install blast
conda install star
conda install bowtie2
conda install rapsearch

echo "installing clustalo, progressiveMauve, dbg2olc, spades"
conda install clustalo
conda install progressiveMauve
conda install dbg2olc
conda install spades

# srst2 requires python 2.7, gets its own environment
echo "creating a python 2.7 environment for srst2"
conda create --name srst2 python=2.7 srst2 

echo "downloading and installing magicblast"
yes | sudo apt install alien

wget -P /tmp/ ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.0.0/ncbi-magicblast-1.0.0-1.x86_64.rpm
sudo alien -i /tmp/ncbi-magicblast-1.0.0-1.x86_64.rpm 

echo "downloading and installing PRICE"
PRICE_PATH=http://derisilab.ucsf.edu/software/price/PriceSource140408.tar.gz
wget -P /tmp/ $PRICE_PATH
mkdir /tmp/price && tar -C /tmp/price -xf /tmp/$(basename $PRICE_PATH) --strip-components 1
cd /tmp/price
make
sudo mv PriceTI PriceSeqFilter /usr/local/bin/
cd $HOME

echo "downloading and installing GSNAP"
sudo apt-get install -y build-essential
GSNAP_PATH=http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-11-15.tar.gz
wget -P /tmp/ $GSNAP_PATH
mkdir /tmp/gmap-gsnap && tar -C /tmp/gmap-gsnap -xf /tmp/$(basename $GSNAP_PATH) --strip-components 1
cd /tmp/gmap-gsnap
./configure --prefix=/home/ubuntu --with-gmapdb=/home/ubuntu/share
make -j 16
sudo make install
/home/ubuntu/bin/gsnapl --version