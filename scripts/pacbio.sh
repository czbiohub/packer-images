#!/bin/bash -x

cd /mnt/data

aws s3 cp s3://czbiohub-scripts/other_software/smrtlink_7.0.1.66975.zip .
aws s3 cp s3://czbiohub-scripts/other_software/smrtlink.config .
unzip smrtlink_7.0.1.66975.zip

sudo sh -c 'echo "* soft nproc 10000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nproc 10000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 10000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nofile 10000" >> /etc/security/limits.conf'

sudo sh -c 'aws s3 cp s3://czbiohub-scripts/other_software/pacbio-postlaunch.sh /var/lib/cloud/scripts/per-instance'
sudo chmod 755 /var/lib/cloud/scripts/per-instance/pacbio-postlaunch.sh

sudo sh -c "echo 'SMRT Link services not ready.' > /etc/motd"

sudo apt-get --purge remove postgresql
sudo apt-get install postgresql-9.6
