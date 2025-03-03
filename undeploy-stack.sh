#!/bin/bash

# Change to the directory where this script is located
script_root="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "${script_root}"

# Check if script is called with one parameter
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 folder"
  exit 1
fi

folder="$1"

# Verify that the AWS CLI is configured
if aws sts get-caller-identity > /dev/null; then
  echo "AWS CLI is configured."
else
  echo "ERROR: AWS CLI is not configured."
  exit 1
fi

set -e

cd "${folder}"

# Configure environment variables
. ./config

echo "Stack name   : ${cf_stack_name}"

# Delete the CloudFormation stack
aws cloudformation delete-stack \
  --stack-name "${cf_stack_name}" \
&& aws cloudformation wait stack-delete-complete \
  --stack-name "${cf_stack_name}"

echo "Stack ${cf_stack_name} deleted."
