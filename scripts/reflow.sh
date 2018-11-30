#!/bin/bash -x

# Remove locks on installing packages.
# Ubuntu's unattended-upgrades is at fault here because it's constantly
# monitoring for package upgrades
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
# while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 1 done

# Get release version of reflow
wget https://github.com/grailbio/reflow/releases/download/reflow0.6.8/reflow0.6.8.linux.amd64
sudo cp reflow0.6.8.linux.amd64 /usr/local/bin/reflow
sudo chmod ugo+x /usr/local/bin/reflow

# test reflow command
reflow -help

# These files are necessary to increase the number of open file limits
# so reflow can run on 1000s of files at once
sudo cp /tmp/common-session /etc/pam.d/common-session
sudo cp /tmp/common-session-noninteractive /etc/pam.d/common-session-noninteractive
sudo cp /tmp/limits.conf /etc/security/limits.conf

# Normally the previous 3 lines would work but there's been a bug in Ubuntu
# since 16.00: https://bugs.launchpad.net/ubuntu/+source/pam/+bug/65244
# This stackoverflow answer has the correct information:
# https://superuser.com/a/1200818/166053
sudo cp /tmp/user.conf /etc/systemd/user.conf
sudo cp /tmp/system.conf /etc/systemd/system.conf


# Install docker - for local reflow runs
sudo apt-get update
sudo apt-get install --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Ensure fingerprint is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install --yes docker-ce
sudo docker run hello-world


# Copy Reflow Configurations to the home directory
sudo cp /tmp/*reflow.sh $HOME

# Make a variable for the profile that can be run by all users, even at build time
PROFILE=/tmp/reflow.bash_profile.sh

# Get some AWS configurations
source $PROFILE

# Add sourcing of these new files to bashrc
echo "source reflow.bash_profile.sh >> ~/.bashrc"
echo "source reflow.bashrc.sh >> ~/.bashrc"

# Add the repository to the config
echo 'repository: s3,czbiohub-reflow-quickstart-cache' >> ~/.reflow/config.yaml


# Clone the github repositories
git clone https://github.com/czbiohub/aguamenti
# Install aguamenti
pushd aguamenti
make conda_install
popd

git clone https://github.com/czbiohub/reflow-workflows

# Install zsh and other niceness
sudo apt-get update
sudo apt install --yes zsh emacs tree git-core unzip htop tmux
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
sudo chsh -s `which zsh`
sudo usermod -s /bin/zsh ubuntu


# Add sourcing of bashrc to zshrc
RCFILE=$HOME/.zshrc
echo "source ~/.bashrc >> $RCFILE"

# # Somehow anaconda gets lost????
# export PATH=$PATH:$HOME/anaconda/bin
# echo "export PATH=$PATH:$HOME/anaconda/bin">> $RCFILE

exit 0
