#!/bin/bash

: ${SECRETS_DIR:=/run/secrets}
: ${IMAGE_NAME:=alpine-env}

c_echo(){
    RED="\033[0;31m"
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\n\033[1m' # No Color

    printf "${!1}${2} ${NC}\n"
}

DOCKER_BUILDKIT=1 docker build -t ${IMAGE_NAME}:test -f ../Dockerfile ../

c_echo "NC" "using SECRETS_DIR : $SECRETS_DIR"

docker \
    run \
    --rm \
    -e AWS_ACCESS_KEY_ID='{{SECRET:AWS_ACCESS_KEY_ID}}' \
    -e AWS_SECRET_ACCESS_KEY='{{SECRET:AWS_SECRET_ACCESS_KEY}}' \
    -v $(pwd)/AWS_ACCESS_KEY_ID:${SECRETS_DIR}/AWS_ACCESS_KEY_ID \
    -v $(pwd)/AWS_SECRET_ACCESS_KEY:${SECRETS_DIR}/AWS_SECRET_ACCESS_KEY \
    ${IMAGE_NAME}:test \
    env > env_vars

if [[ "12345" = $(cat env_vars | grep AWS_ACCESS_KEY_ID | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with secrets - AWS_ACCESS_KEY_ID - passed"
else
    c_echo "RED" "Test with secrets - AWS_ACCESS_KEY_ID - failed"
fi

if [[ "zxcasdqwe" = $(cat env_vars | grep AWS_SECRET_ACCESS_KEY | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with secrets - AWS_SECRET_ACCESS_KEY - passed"
else
    c_echo "RED" "Test with secrets - AWS_SECRET_ACCESS_KEY - failed"
fi

rm env_vars

docker \
    run \
    --rm \
    -e AWS_ACCESS_KEY_ID='12345' \
    -e AWS_SECRET_ACCESS_KEY='zxcasdqwe'  \
    ${IMAGE_NAME}:test \
    env > env_vars

if [[ "12345" = $(cat env_vars | grep AWS_ACCESS_KEY_ID | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with env - AWS_ACCESS_KEY_ID - passed "
else
    c_echo "RED" "Test with env - AWS_ACCESS_KEY_ID - failed"
fi

if [[ "zxcasdqwe" = $(cat env_vars | grep AWS_SECRET_ACCESS_KEY | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with env - AWS_SECRET_ACCESS_KEY - passed"
else
    c_echo "RED" "Test with env - AWS_SECRET_ACCESS_KEY - failed"
fi

rm env_vars


SECRETS_DIR=/etc/secrets

c_echo "NC" "using SECRETS_DIR : $SECRETS_DIR"

docker \
    run \
    --rm \
    -e AWS_ACCESS_KEY_ID='{{SECRET:AWS_ACCESS_KEY_ID}}' \
    -e AWS_SECRET_ACCESS_KEY='{{SECRET:AWS_SECRET_ACCESS_KEY}}' \
    -e SECRETS_DIR=${SECRETS_DIR} \
    -v $(pwd)/AWS_ACCESS_KEY_ID:${SECRETS_DIR}/AWS_ACCESS_KEY_ID \
    -v $(pwd)/AWS_SECRET_ACCESS_KEY:${SECRETS_DIR}/AWS_SECRET_ACCESS_KEY \
    ${IMAGE_NAME}:test \
    env > env_vars

if [[ "12345" = $(cat env_vars | grep AWS_ACCESS_KEY_ID | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with secrets in $SECRETS_DIR- AWS_ACCESS_KEY_ID - passed"
else
    c_echo "RED" "Test with secrets in $SECRETS_DIR- AWS_ACCESS_KEY_ID - failed"
fi

if [[ "zxcasdqwe" = $(cat env_vars | grep AWS_SECRET_ACCESS_KEY | cut -f2 -d"=") ]]; then
    c_echo "GREEN" "Test with secrets in $SECRETS_DIR- AWS_SECRET_ACCESS_KEY - passed"
else
    c_echo "RED" "Test with secrets in $SECRETS_DIR- AWS_ACCESS_KEY_ID - failed"
fi

rm env_vars
