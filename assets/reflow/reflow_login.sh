# Should only be run when the user logs in, because don't want multiple users
# appended into the reflow config
# Shouldn't be run at build time

# Should be run after aegea launching the instance

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
# reflow setup-dynamodb-assoc czbiohub-reflow-quickstart

# Add the repository to the config
echo 'repository: s3,czbiohub-reflow-quickstart-cache' >> ~/.reflow/config.yaml

echo "user: local,$HOST@localhost" >> ~/.reflow/config.yml
git clone https://github.com/czbiohub/reflow-batches

# Get latest versions of aguamenti and reflow-workflows
pushd ~/aguamenti && git pull origin master
pushd ~/reflow-workflows && git pull origin master
popd
popd
