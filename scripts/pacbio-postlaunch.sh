#!/bin/bash -x

set -e

# During the packer build process for pac bio image - this script is
# copied to /var/lib/cloud/scripts/per-instance and thus will be run
# each time instance is launched

sudo sh -c 'echo "127.0.0.1 $(cat /etc/hostname)" >> /etc/hosts'
cd /mnt/data
publicDNS="$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
sed -i "s/biohubisawesome/$publicDNS/g" smrtlink.config
runuser -l ubuntu -c "cd /mnt/data && ./smrtlink_7.0.1.66975.run --configfile smrtlink.config --batch"
cd smrtlink/admin/bin
runuser -l ubuntu -c "bash /mnt/data/smrtlink/admin/bin/services-start"
sudo sh -c "echo 'SMRT LINK services ready. Go to ${publicDNS}:9090' > /etc/motd"
wall "SMRTLINK services ready. Go to ${publicDNS}:9090"
