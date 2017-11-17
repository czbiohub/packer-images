#!/bin/bash

wget -q ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M15/gencode.vM15.annotation.gtf.gz
tar -xzvf gencode.vM15.annotation.gtf.gz
velocyto extract_intervals gencode.vM15.annotation.gtf -p gencode.vM15.annotation.velocyto_intervals.gtf
aws s3 cp gencode.vM15.annotation.velocyto_intervals.gtf s3://olgabot-genomes/mus/mm10/gencode/m15/gencode.vM15.annotation.velocyto_intervals.gtf
