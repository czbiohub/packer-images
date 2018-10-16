#!/bin/bash -x

# These files are necessary to increase the number of open file limits
# https://superuser.com/a/1200818/166053
sudo cp /tmp/common-session /etc/pam.d/common-session
sudo cp /tmp/common-session-noninteractive /etc/pam.d/common-session-noninteractive
sudo cp /tmp/limits.conf /etc/security/limits.conf
sudo cp /tmp/user.conf /etc/systemd/user.conf
sudo cp /tmp/system.conf /etc/systemd/system.conf

export PATH=$HOME/anaconda/bin:$PATH

conda install python=3.6
conda install numpy scipy pandas matplotlib seaborn ruamel.yaml
conda install minimap2 samtools bcftools pysam plink raxml snakemake biopython
