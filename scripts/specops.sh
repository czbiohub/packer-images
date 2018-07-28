#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

echo "install blast, star, rapsearch"
conda install --verbose blast
conda install --verbose star
conda install --verbose rapsearch

<<<<<<< HEAD
echo "installing clustalo, trimmomatic, bcftools, samtools, fastqc, adapterremoval, minimap2, seqtk, progressiveMauve, dbg2olc, spades, bowtie2"
=======
echo "installing clustalo, bcftools, samtools, fastqc, adapterremoval, minimap2, seqtk, progressiveMauve, dbg2olc, spades, bowtie2"
>>>>>>> 443576ca16b7963496038005bd8204ee9988748b
conda install --verbose clustalo
conda install --verbose progressiveMauve
conda install --verbose dbg2olc
conda install --verbose spades
conda install --verbose bowtie2
conda install --verbose seqtk
conda install --verbose samtools
conda install --verbose bcftools
conda install --verbose fastqc
conda install --verbose adapterremoval
conda install --verbose minimap2
<<<<<<< HEAD
conda install --verbose trimmomatic
=======
>>>>>>> 443576ca16b7963496038005bd8204ee9988748b

yes | conda clean --all

# srst2 requires python 2.7, gets its own environment
# it depends on bowtie2 so that will go in here too
echo "creating a python 2.7 environment for bowtie2 and srst2"
conda create --name py2 python=2.7 bowtie2=2.2.8 srst2 rseqc

yes | conda clean --all

df -h

echo "downloading and installing magicblast"
yes | sudo apt-get install alien

echo "installing unzip"
yes | sudo apt-get install unzip
df -h

wget -P /tmp/ ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.0.0/ncbi-magicblast-1.0.0-1.x86_64.rpm
sudo alien -i /tmp/ncbi-magicblast-1.0.0-1.x86_64.rpm

echo "installing cutadapt"
pip3 install cutadapt

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
<<<<<<< HEAD
GSNAP_PATH=http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-11-15.tar.gz
wget -P /tmp/ $GSNAP_PATH
mkdir /tmp/gmap-gsnap && tar -C /tmp/gmap-gsnap -xf /tmp/$(basename $GSNAP_PATH) --strip-components 1
rm /tmp/$(basename $GSNAP_PATH)
cd /tmp/gmap-gsnap
./configure --prefix=/home/ubuntu --with-gmapdb=/home/ubuntu/share
make V=1 -j 16
make install
/home/ubuntu/bin/gsnapl --version
=======
# GSNAP_PATH=http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-11-15.tar.gz
# wget -P /tmp/ $GSNAP_PATH
# mkdir /tmp/gmap-gsnap && tar -C /tmp/gmap-gsnap -xf /tmp/$(basename $GSNAP_PATH) --strip-components 1
# rm /tmp/$(basename $GSNAP_PATH)
# cd /tmp/gmap-gsnap
# ./configure --prefix=/home/ubuntu --with-gmapdb=/home/ubuntu/share
# make V=1 -j 16
# make install
# /home/ubuntu/bin/gsnapl --version
>>>>>>> 443576ca16b7963496038005bd8204ee9988748b

echo "downloading and installing unicycler"
UNI_PATH=https://github.com/rrwick/Unicycler/archive/v0.4.6.zip
wget -P /tmp/ $UNI_PATH
cd /tmp/
unzip $(basename $UNI_PATH)
sleep 10
rm $(basename $UNI_PATH)
cd Unicycler-0.4.6
python3 setup.py install

echo "downloading and installing DASHit"
conda install --verbose go
echo "export GOPATH=$HOME/go" >> ~/.bashrc
source ~/.bashrc
go get github.com/shenwei356/bio/seq
go get github.com/shenwei356/bio/seqio/fastx
go get github.com/shenwei356/xopen
ln -s /home/ubuntu/anaconda/bin/pip /home/ubuntu/anaconda/bin/pip3
DASHIT_PATH=https://github.com/czbiohub/guide_design_tools
cd /tmp
git clone $DASHIT_PATH
mkdir -p ~/.config/czbiohub
echo "License accept override for Biohub internal use" > $HOME/.config/czbiohub/guide_design_tools.txt
cd guide_design_tools
yes|make install
cp /tmp/guide_design_tools/vendor/special_ops_crispr_tools/crispr_sites/crispr_sites $HOME/bin
cp /tmp/guide_design_tools/vendor/special_ops_crispr_tools/offtarget/offtarget $HOME/bin

