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

echo "Template file: ${cf_template_file}"
echo "Stack name   : ${cf_stack_name}"
echo "Param file   : ${parameter_file}"

# Read parameters
parameters=$(cat "${parameter_file}")

set +e

# Check if CF stack exists
aws cloudformation describe-stacks --stack-name "${cf_stack_name}" >/dev/null 2>&1
describe_result=$?

# If exists, update
if [[ $describe_result -eq 0 ]]; then
  echo "Update CF stack"

  update_output=$(aws cloudformation update-stack \
  --stack-name "${cf_stack_name}" \
  --template-body "${cf_template_body}" \
  --parameters "${parameters}" \
  --capabilities CAPABILITY_NAMED_IAM )

  update_result=$?
  echo "${update_output}"

  if [ $update_result -eq 0 ]; then
    aws cloudformation wait stack-update-complete \
    --stack-name "${cf_stack_name}"
  else
    if [[ "${update_output}" =~ .*"No updates are to be performed".* ]]; then
      echo "Nothing to update, ignoring error."
    else
      exit $update_result
    fi
  fi

# Create if not exists
else
  echo "Create CF stack"

  aws cloudformation create-stack \
  --stack-name "${cf_stack_name}" \
  --template-body "${cf_template_body}" \
  --parameters "${parameters}" \
  --capabilities CAPABILITY_NAMED_IAM \
  && aws cloudformation wait stack-create-complete \
  --stack-name "${cf_stack_name}"

fi
