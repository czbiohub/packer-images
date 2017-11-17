#!/bin/bash

aws s3 cp s3://czbiohub-maca/data/170517_NS500126_0699_AH7YVJBGX2/results/N394Barcode_701-502.homo.tgz .
aws s3 cp s3://olgabot-genomes/mus/mm10/gencode/m15/gencode.vM15.annotation.velocyto_intervals.gtf .
tar xzvf N394Barcode_701-502.homo.tgz
velocyto run gencode.vM15.annotation.velocyto_intervals.gtf results/Pass1/Aligned.out.sorted.bam
aws s3 cp 
