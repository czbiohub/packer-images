# TODO: can we use set -xe??

sudo apt-get install unzip
# TODO: Not sure why this magic is needed
sudo apt-get -f install --yes && sudo dpkg --configure -a

# isPcr
cd /mnt/data
wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/isPcr.zip && mkdir isPcr && unzip isPcr.zip -d isPcr
ln -s /mnt/data/isPcr ~/isPcr
# blat
mkdir blat && wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/blatSuite.zip && unzip blatSuite.zip -d blat
ln -s /mnt/data/blat ~/blat

# python2, twoBitToFa
export PATH=$HOME/anaconda/bin:$PATH
conda create -n python2 anaconda python=2 && source activate python2
conda install -c bioconda ucsc-twobittofa

# fastinterval
sudo apt-get install -y liblzo2-dev zlib1g-dev
pip install fastinterval

# Primer3
sudo apt-get install -y primer3

# genomes
cd /mnt/data
mkdir genome && cd genome
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.2bit
twoBitToFa hg38.2bit hg38.fa
wget http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/mm10.2bit
twoBitToFa mm10.2bit mm10.fa
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/snp142Mask/chr*.subst.fa.gz
ln -s /mnt/data/genome ~/genome

# SNP genomes
cd /mnt/data/genome
mkdir hg38snp142 && hg38snp142
curl --remote-name-all http://hgdownload.cse.ucsc.edu/goldenPath/hg38/snp142Mask/chr[1-22].subst.fa.gz
curl --remote-name-all http://hgdownload.cse.ucsc.edu/goldenPath/hg38/snp142Mask/chr{X,Y}.subst.fa.gz
gzip -d *.gz
# TODO: is order important???
cat *.subst.fa > ../hg38.snp142.fa

cd /mnt/data/genome
mkdir mm10snp142 && mm10snp142
curl --remote-name-all http://hgdownload.cse.ucsc.edu/goldenPath/mm10/snp142Mask/chr[1-19].subst.fa.gz
curl --remote-name-all http://hgdownload.cse.ucsc.edu/goldenPath/mm10/snp142Mask/chr{X,Y}.subst.fa.gz
gzip -d *.gz
# TODO: is order important???
cat *.subst.fa > ../mm10.snp142.fa


# ./crispr_primer.py -f example_input.bed.csv -g hg38 -o example_output.csv