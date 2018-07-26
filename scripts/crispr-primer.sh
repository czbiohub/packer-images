# TODO: can we use set -xe??

sudo apt-get install unzip
# TODO: Not sure why this magic is needed
sudo apt-get -f install --yes && sudo dpkg --configure -a

cd /mnt/data
wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/isPcr.zip && mkdir isPcr && unzip isPcr.zip -d isPcr
ln -s /mnt/data/isPcr ~/isPcr
mkdir blat && wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/blatSuite.zip && unzip blatSuite.zip -d blat
ln -s /mnt/data/blat ~/blat

export PATH=$HOME/anaconda/bin:$PATH
conda create -n python2 anaconda python=2 && source activate python2
conda install -c bioconda primer3 ucsc-twobittofa

cd /mnt/data
mkdir genome && cd genome
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.2bit
twoBitToFa hg38.2bit hg38.fa
wget http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/mm10.2bit
twoBitToFa mm10.2bit mm10.fa
ln -s /mnt/data/genome ~/genome

sudo apt-get install -y liblzo2-dev zlib1g-dev
pip install fastinterval

# TODO: download mask snp142 from USCS and cat into one big file.
# snp142mask/chr1.subst.fa.gz to chr22 plus X and Y

# TODO: turn back on PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT
# by setting PRIMER_THERMODYNAMIC_PARAMETERS_PATH
# see https://mcardle.wisc.edu/mprime/help/primer3/primer3_manual.htm#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT

# TODO: still need snp genomes
# ./crispr-primer/crispr_primer.py -f example_input.bed.csv -g hg38 -o example_output.csv