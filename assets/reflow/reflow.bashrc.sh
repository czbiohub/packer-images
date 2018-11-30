# Should only be run when the user logs in, because don't want multiple users
# appended into the reflow config
# Shouldn't be run at build time

echo "user: local,$HOST@localhost" >> ~/.reflow/config.yml
