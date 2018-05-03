#!/bin/bash

wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
tar -xzf tophat-2.1.1.Linux_x86_64.tar.gz 

sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam2fastx /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam_merge /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bed_to_juncs /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/contig_to_chr_coords /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/fix_map_ordering /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_juncs /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_to_fasta /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/juncs_db /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/long_spanning_reads /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/prep_reads /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sam_juncs /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/samtools_0.1.18 /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/segment_juncs /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sra_to_solid /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat2 /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat-fusion-post /usr/local/bin
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat_reports /usr/local/bin

sudo rm /home/ubuntu/tophat-2.1.1.Linux_x86_64.tar.gz
sudo rm -r /home/ubuntu/tophat-2.1.1.Linux_x86_64

