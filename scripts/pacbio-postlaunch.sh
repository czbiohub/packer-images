#!/bin/bash -x
# During the packer build process for pac bio image - this script is
# copied to /var/lib/cloud/scripts/per-instance and thus will be run
# each time instance is launched
cd /mnt/data
publicDNS="$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
sed -i "s/biohubisawesome/$publicDNS/g" smrtlink.config
./smrtlink_7.0.1.66975.run --configfile smrtlink.config --batch
