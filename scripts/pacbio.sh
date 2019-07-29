#!/bin/bash -x

cd /mnt/data

aws s3 cp s3://czbiohub-scripts/other_software/smrtlink_7.0.1.66975.zip .
aws s3 cp s3://czbiohub-scripts/other_software/smrtlink.config .
sudo apt-get install zip unzip
gunzip smrtlink_7.0.1.66975.zip.gz
unzip smrtlink_7.0.1.66975.zip
ulimit -u 10000
ulimit -n 10000

aws s3 cp s3://czbiohub-scripts/other_software/pacbio-postlaunch.sh /var/lib/cloud/scripts/per-instance
chmod 755 /var/lib/cloud/scripts/per-instance/pacbio-postlaunch.sh
