#!/bin/bash

# Fail fast
set -e

# This is the order of arguments
build_folder=$1
dockerfile_folder=$2
aws_ecr_repository_url_with_tag=$3
aws_region=$4

# Allow overriding the aws region from system
if [ "$aws_region" != "" ]; then
  aws_extra_flags="--region $aws_region"
else
  aws_extra_flags=""
fi

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

# Some Useful Debug
echo "Building $aws_ecr_repository_url_with_tag from $dockerfile_folder/Dockerfile"

echo "docker build -t $aws_ecr_repository_url_with_tag -f $dockerfile_folder/Dockerfile $build_folder"
# Build image
docker build -t $aws_ecr_repository_url_with_tag -f "$dockerfile_folder/Dockerfile" $build_folder

# Connect into aws
$(aws ecr get-login --no-include-email $aws_extra_flags) || { echo 'ERROR: aws ecr login failed' ; exit 1; }

# Push image
docker push $aws_ecr_repository_url_with_tag
