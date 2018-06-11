#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

echo "install blast, star, rapsearch"
conda install --verbose blast
conda install --verbose star
conda install --verbose rapsearch

echo "installing clustalo, progressiveMauve, dbg2olc, spades"
conda install --verbose clustalo
conda install --verbose progressiveMauve
conda install --verbose dbg2olc
conda install --verbose spades
conda install --verbose unicycler

yes | conda clean --all

# srst2 requires python 2.7, gets its own environment
# it depends on bowtie2 so that will go in here too
echo "creating a python 2.7 environment for bowtie2 and srst2"
conda create --name py2 python=2.7 bowtie2 srst2 rseqc

yes | conda clean --all

df -h

echo "downloading and installing magicblast"
yes | sudo apt-get install alien

df -h

wget -P /tmp/ ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.0.0/ncbi-magicblast-1.0.0-1.x86_64.rpm
sudo alien -i /tmp/ncbi-magicblast-1.0.0-1.x86_64.rpm

echo "downloading and installing PRICE"
PRICE_PATH=http://derisilab.ucsf.edu/software/price/PriceSource140408.tar.gz
wget -P /tmp/ $PRICE_PATH
mkdir /tmp/price && tar -C /tmp/price -xf /tmp/$(basename $PRICE_PATH) --strip-components 1
rm /tmp/$(basename $PRICE_PATH)
cd /tmp/price
make V=1
sudo mv PriceTI PriceSeqFilter /usr/local/bin/
cd $HOME

df -h

echo "downloading and installing GSNAP"
sudo apt-get install -y build-essential
GSNAP_PATH=http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-11-15.tar.gz
wget -P /tmp/ $GSNAP_PATH
mkdir /tmp/gmap-gsnap && tar -C /tmp/gmap-gsnap -xf /tmp/$(basename $GSNAP_PATH) --strip-components 1
rm /tmp/$(basename $GSNAP_PATH)
cd /tmp/gmap-gsnap
./configure --prefix=/home/ubuntu --with-gmapdb=/home/ubuntu/share
make V=1 -j 16
sudo make install
/home/ubuntu/bin/gsnapl --version
