#!/bin/bash

# sleep until the instance is ready
for try in {1..100}; do
    if [[ $try -gt 1 ]]
    then
        echo "sleeping 10 sec"
        sleep 10
    fi
    sudo dpkg --configure -a || continue
    break
done

# install updates and upgrades
sudo apt-get -f install
sudo apt-get update
sudo apt-get upgrade -y

# install make, g++, awscli
yes | sudo apt-get install make
yes | sudo apt-get install g++
# this installs packages to system python3 but that's okay
yes | sudo apt-get install awscli

exit 0
