#!/bin/bash

wget -O fastxtoolkit.tar.bz2 http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2

mkdir fastxlatest
tar xvjf fastxtoolkit.tar.bz2 -C /home/ubuntu/fastxlatest/
cd fastxlatest
version=$(ls)

cd $version

currdir=$(pwd)


sudo cp $currdir/fasta_clipping_histogram.pl /usr/local/bin
sudo cp $currdir/fasta_formatter /usr/local/bin
sudo cp $currdir/fasta_nucleotide_changer /usr/local/bin
sudo cp $currdir/fastq_masker /usr/local/bin
sudo cp $currdir/fastq_quality_boxplot_graph.sh /usr/local/bin
sudo cp $currdir/fastq_quality_converter /usr/local/bin
sudo cp $currdir/fastq_quality_filter /usr/local/bin
sudo cp $currdir/fastq_quality_trimmer /usr/local/bin
sudo cp $currdir/fastq_to_fasta /usr/local/bin
sudo cp $currdir/fastx_artifacts_filter /usr/local/bin
sudo cp $currdir/fastx_barcode_splitter.pl /usr/local/bin
sudo cp $currdir/fastx_clipper /usr/local/bin
sudo cp $currdir/fastx_collapser /usr/local/bin
sudo cp $currdir/fastx_nucleotide_distribution_graph.sh /usr/local/bin
sudo cp $currdir/fastx_nucleotide_distribution_line_graph.sh /usr/local/bin
sudo cp $currdir/fastx_quality_stats /usr/local/bin
sudo cp $currdir/fastx_renamer /usr/local/bin
sudo cp $currdir/fastx_reverse_complement /usr/local/bin
sudo cp $currdir/fastx_trimmer /usr/local/bin
sudo cp $currdir/fastx_uncollapser /usr/local/bin



sudo rm /home/ubuntu/fastxtoolkit.tar.bz2
sudo rm -r /home/ubuntu/fastxlatest

echo "finished with fastxtoolkit"

exit 0

