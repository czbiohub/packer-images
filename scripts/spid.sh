#!/bin/bash -x

export PATH=$HOME/anaconda/bin:$PATH

conda install python=3.6
conda install numpy scipy pandas matplotlib seaborn ruamel.yaml
conda install minimap2 samtools bcftools pysam plink raxml snakemake biopython
