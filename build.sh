#!/bin/sh
# PURPOSE: build script for this project

# -- auto: path variables
scriptSelf=$0;
scriptName=$(basename $scriptSelf)
scriptCallDir=$(dirname $scriptSelf)
scriptFullDir=$(cd $scriptCallDir;echo $PWD)
scriptFullPath=$scriptFullDir/$scriptName;
scriptParentDir=$(dirname $scriptFullDir)
# -- /auto: path variables


# -- vars: project properties
PROJECT_NAME="$( basename ${scriptFullDir})"
IMAGE_NAME="${PROJECT_NAME}:build"

# -- initialisation tasks
set -e
cd ${scriptFullDir}
echo;echo;echo "--"


# build local image first
echo "[>] building local image ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .

# compute tag name
case "${CI_COMMIT_REF_NAME}" in
  master)
    TAG_NAME="latest"
    ;;
  *)
    TAG_NAME="${CI_COMMIT_REF_NAME:-testing}"
    ;;
esac


# push to local registry
if [ -n ${CI_REGISTRY_USER} ] && [ -n ${CI_REGISTRY_PASSWORD} ] && [ -n ${CI_REGISTRY_IMAGE} ];then
  docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
  docker tag ${IMAGE_NAME} ${CI_REGISTRY_IMAGE}:${TAG_NAME}
  docker push ${CI_REGISTRY_IMAGE}:${TAG_NAME}
  echo "[i] docker image for [${PROJECT_NAME}] has been pushed to ${CI_REGISTRY_IMAGE}:${TAG_NAME}"
fi


# push to docker hub
if [ -n ${DOCKER_HUB_USER} ] && [ -n ${DOCKER_HUB_PASS} ] && [ -n ${DOCKER_HUB_IMAGE} ];then
  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASS}
  docker tag ${IMAGE_NAME} ${DOCKER_HUB_IMAGE}:${TAG_NAME}
  docker push ${DOCKER_HUB_IMAGE}:${TAG_NAME}
  echo "[i] docker image for [${PROJECT_NAME}] has been pushed to ${DOCKER_HUB_IMAGE}:${TAG_NAME}"
fi


# eof
