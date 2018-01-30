#!/bin/bash -x


echo "Installing Node and NPM"
yes | sudo apt-get install nodejs npm

echo "Installing bionode"
npm install bionode-ncbi -g
npm install bionode-sra -g

echo "Done with bionode setup"

exit 0