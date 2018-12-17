SHELL=/usr/bin/zsh

# Copy files and logs to AWS EC2
@hourly aws s3 sync /home/ubuntu/reflow-batches s3://czbiohub-reflow-logs/reflow-batches/

# Commit any changes to reflow-batches
@daily cd /home/ubuntu/reflow-batches && git add -A "Auto-commit on $(date) from $(hostname)" && git pull origin master && git push origin master

# Set up AWS configuration and EC2 commands
@reboot /home/ubuntu/reflow_startup.sh
