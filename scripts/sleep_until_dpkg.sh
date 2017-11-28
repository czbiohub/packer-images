#!/bin/bash
echo "sleeping 30 sec"; sleep 30
for try in {1..100}; do if [[ $try -gt 1 ]]; then echo "sleeping 10 sec"; sleep 10; fi; sudo dpkg --configure -a || continue; break; done
sudo apt-get -f install
sudo apt-get update
sudo apt-get upgrade -y
yes | sudo apt-get install make
yes | sudo apt-get install g++
yes | sudo apt-get install awscli

exit 0
