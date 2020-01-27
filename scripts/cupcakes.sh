export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH'

git clone https://github.com/czbiohub/cupcakes.git
conda env update --name root --file cupcakes/2018/olgas_bioinformagician_tricks/environment.yml

conda list

conda info -a


## Show available environments upon login
echo "conda env list" >> ~/.bashrc
source ~/.bashrc
