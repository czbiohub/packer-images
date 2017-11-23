#!/bin/bash

yes | sudo apt-get install python-pip
sudo pip install --upgrade pip

sudo pip install biopython

echo "finished with biopython"

exit 0
