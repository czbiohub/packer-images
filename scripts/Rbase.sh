sleep 30
echo 'sleeping 30 sec'; sleep 30

yes | sudo add-apt-repository "deb http://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -sc)/"

yes | sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
yes | sudo add-apt-repository ppa:marutter/rdev
yes | apt-get update ; DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
yes | sudo apt-get install r-base
echo "done building Rbase"
exit 0