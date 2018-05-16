sudo apt-get install build-essential curl file git python-setuptools
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo 'export PATH="/home/ubuntu/.linuxbrew/bin:$PATH"' >>~/.profile
echo 'export MANPATH="/home/ubuntu/.linuxbrew/share/man:$MANPATH"' >>~/.profile
echo 'export INFOPATH="/home/ubuntu/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
export PATH="/home/ubuntu/.linuxbrew/bin:$PATH"
brew install gcc
brew install hello
brew doctor
