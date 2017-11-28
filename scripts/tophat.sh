#!/bin/bash
echo "sleeping 30 sec"; sleep 30

wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
tar -xzf tophat-2.1.1.Linux_x86_64.tar.gz 

sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam2fastx /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bam_merge /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/bed_to_juncs /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/contig_to_chr_coords /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/fix_map_ordering /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_juncs /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/gtf_to_fasta /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/juncs_db /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/long_spanning_reads /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/prep_reads /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sam_juncs /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/samtools_0.1.18 /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/segment_juncs /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/sra_to_solid /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat2 /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat-fusion-post /bin/
sudo cp /home/ubuntu/tophat-2.1.1.Linux_x86_64/tophat_reports /bin/

sudo rm tophat-2.1.1.Linux_x86_64.tar.gz
sudo rm -r tophat-2.1.1.Linux_x86_64