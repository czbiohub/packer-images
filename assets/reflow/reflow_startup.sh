#!/bin/bash

# Should only be run when the user logs in, because don't want multiple users
# appended into the reflow config
# Shouldn't be run at build time

# Should be run after aegea launching the instance
export PATH=$PATH:$HOME/anaconda/bin

AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
AWS_ACCESS_KEY_ID=$(python -c 'import boto3; print(boto3.session.Session().get_credentials().access_key)')
AWS_SECRET_ACCESS_KEY=$(python -c 'import boto3; print(boto3.session.Session().get_credentials().secret_key)')
AWS_SESSION_TOKEN=$(python -c 'import boto3; print(boto3.session.Session().get_credentials().token)')
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_DEFAULT_REGION

# Tell Reflow to load AWS credentials the way Aegea stores them
export AWS_SDK_LOAD_CONFIG=1

# --- Now we're ready to set up Reflow --- $
# Send reflow setup commands to bashrc so they get set up for every user's AWS credentials
reflow setup-ec2

# Add the repository to the config
# reflow setup-dynamodb-assoc czbiohub-reflow-quickstart
echo 'repository: s3,czbiohub-reflow-quickstart-cache' >> ~/.reflow/config.yaml

echo "user: local,$(hostname)@localhost" >> ~/.reflow/config.yaml
git clone https://github.com/czbiohub/reflow-batches

# Get latest versions of aguamenti and reflow-workflows
pushd ~/aguamenti && git pull
pushd ~/reflow-workflows && git pull
pushd ~/reflow-batches && git pull
popd

#
# # ## Make tmux Session with windows setup
# tmux -2 new-session -d -s reflow
# tmux split-window -h
# tmux select-pane -t 0
# tmux split-window -v
# tmux split-window -v
# # Top left window shows memory and CPU usage
# tmux select-pane -t 0
# tmux send-keys "htop" C-m
# # Middle left window shows number of done, running, canceled, etc jobs
# tmux select-pane -t 1
# tmux send-keys "watch aguamenti status" C-m
#
# # Bottom left window shows currently running reflow processes
# tmux select-pane -t 2
# tmux send-keys "watch reflow ps" C-m
#
# # Change to right pane which is "working" pane for running reflow runbatch
# tmux select-pane -t 3
