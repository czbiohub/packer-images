#!/bin/bash

wget -O fastxtoolkit.tar.bz2 http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2

mkdir fastxlatest
tar xvjf fastxtoolkit.tar.bz2 -C /home/ubuntu/fastxlatest/
cd fastxlatest
version=$(ls)

cd $version

currdir=$(pwd)

mkdir $HOME/bin

sudo cp $currdir/fasta_clipping_histogram.pl $HOME/bin
sudo cp $currdir/fasta_formatter $HOME/bin
sudo cp $currdir/fasta_nucleotide_changer $HOME/bin
sudo cp $currdir/fastq_masker $HOME/bin
sudo cp $currdir/fastq_quality_boxplot_graph.sh $HOME/bin
sudo cp $currdir/fastq_quality_converter $HOME/bin
sudo cp $currdir/fastq_quality_filter $HOME/bin
sudo cp $currdir/fastq_quality_trimmer $HOME/bin
sudo cp $currdir/fastq_to_fasta $HOME/bin
sudo cp $currdir/fastx_artifacts_filter $HOME/bin
sudo cp $currdir/fastx_barcode_splitter.pl $HOME/bin
sudo cp $currdir/fastx_clipper $HOME/bin
sudo cp $currdir/fastx_collapser $HOME/bin
sudo cp $currdir/fastx_nucleotide_distribution_graph.sh $HOME/bin
sudo cp $currdir/fastx_nucleotide_distribution_line_graph.sh $HOME/bin
sudo cp $currdir/fastx_quality_stats $HOME/bin
sudo cp $currdir/fastx_renamer $HOME/bin
sudo cp $currdir/fastx_reverse_complement $HOME/bin
sudo cp $currdir/fastx_trimmer $HOME/bin
sudo cp $currdir/fastx_uncollapser $HOME/bin



sudo rm /home/ubuntu/fastxtoolkit.tar.bz2
sudo rm -r /home/ubuntu/fastxlatest

echo "finished with fastxtoolkit"

exit 0

