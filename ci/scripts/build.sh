#!/bin/bash

set -e

if [[ ! "${TRAVIS}" ]]; then
  echo "This script should be only run from travis-ci. Exiting."
  exit 0
fi

IMAGE="quay.io/hellofresh/ci-terraform"
TAG="${VERSION}"

docker build -t ${IMAGE}:${TAG} .

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]] && [[ "${TRAVIS_BRANCH}" == "master" ]]; then
  docker login --username="$QUAY_USER" --password="$QUAY_PASS" quay.io
  docker push ${IMAGE}:${TAG}

  if [[ "$LATEST_VERSION" == "true" ]]; then
    docker tag ${IMAGE}:${TAG} ${IMAGE}:latest
    docker push ${IMAGE}:latest
  fi
else
  echo "Pull request build, don't push images"
fi
