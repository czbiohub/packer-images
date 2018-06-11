export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' 

conda create --yes -n python2.7-env python=2.7 biopython matplotlib scipy numpy pandas seaborn
source activate python2.7-env
# Force linking of env python2
sudo ln -s /home/ubuntu/anaconda/envs/python2.7-env/bin/python2.7 /usr/bin/python2
sudo ln -s /home/ubuntu/anaconda/envs/python2.7-env/bin/python2.7 /usr/bin/python

sudo apt install --yes cmake

git clone https://github.com/yana-safonova/ig_repertoire_constructor/
cd ig_repertoire_constructor
make
/home/ubuntu/anaconda/envs/python2.7-env/bin/python2.7 igrec.py --test
/home/ubuntu/anaconda/envs/python2.7-env/bin/python2.7 barcoded_igrec.py --test