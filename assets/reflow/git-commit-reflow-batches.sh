#!/bin/bash

cd /home/ubuntu/reflow-batches && git add -A "Auto-commit on $(date) from $(hostname)" && git pull && git push
