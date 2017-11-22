#!/bin/bash

wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
tar -xzf tophat-2.1.1.Linux_x86_64.tar.gz 

mkdir $HOME/bin

sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam2fastx $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam_merge $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bed_to_juncs $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/contig_to_chr_coords $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/fix_map_ordering $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_juncs $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_to_fasta $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/juncs_db $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/long_spanning_reads $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/prep_reads $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sam_juncs $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/samtools_0.1.18 $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/segment_juncs $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sra_to_solid $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat2 $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat-fusion-post $HOME/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat_reports $HOME/bin

sudo rm /home/ubuntu/tophat-2.1.1.Linux_x86_64.tar.gz
sudo rm -r /home/ubuntu/tophat-2.1.1.Linux_x86_64

