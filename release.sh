#!/bin/bash

set -ex

USERNAME=emzian7
IMAGE=alpine-base

git pull origin master
git add .
git commit

./version_bump.sh
VERSION=`cat VERSION`
echo "VERSION: ${VERSION}"

# run build
./build.sh

git push origin master
git push --tags

docker tag ${USERNAME}/${IMAGE}:latest ${USERNAME}/${IMAGE}:${VERSION}
docker push ${USERNAME}/${IMAGE}:latest
docker push ${USERNAME}/${IMAGE}:${VERSION}

docker container prune -f
docker volume prune -f
docker rmi ${USERNAME}/${IMAGE}:latest
docker rmi ${USERNAME}/${IMAGE}:${VERSION}
