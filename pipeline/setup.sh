#!/usr/bin/env bash

set -ex

PIPELINE_NAME=aws-ref-arch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

[ $BRANCH_NAME != "master" ] && PIPELINE_NAME="${PIPELINE_NAME}_${BRANCH_NAME}"

fly set-pipeline \
    -t $TARGET -p $PIPELINE_NAME \
    -c ./pipeline/pipeline.yml \
    --load-vars-from ./pipeline/variables.yml \
    --load-vars-from $SECRETS_FILE \
    -v branch=$BRANCH_NAME \
    -v pipeline-name=$PIPELINE_NAME

fly unpause-pipeline -t $TARGET -p $PIPELINE_NAME

echo "Done!"
