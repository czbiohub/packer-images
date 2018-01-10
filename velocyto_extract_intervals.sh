#!/bin/bash

pip install awscli
aws s3 cp s3://czi-hca/ref-genome/mm10-plus.gtf .
velocyto extract_intervals mm10-plus.gtf -p mm10-plus.velocyto.gtf
