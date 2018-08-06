#!/bin/bash

set -e

if [[ ! "${TRAVIS}" ]]; then
  echo "This script should be only run from travis-ci. Exiting."
  exit 0
fi

IMAGE="quay.io/hellofresh/ci-terraform"
TAG="${VERSION}-${VARIANT}"

CHANGES=$(git diff --name-only ${TRAVIS_COMMIT_RANGE})

[[ -n "$(grep "^${VERSION}/${VARIANT}" <<< "$CHANGES")" ]] && BUILD_REQUIRED=1

if [[ -z ${BUILD_REQUIRED} ]]; then
  echo "Version ${TAG} wasn't changed. Nothing to do."
  exit 0
fi

docker build -t ${IMAGE}:${TAG} ./${VERSION}/${VARIANT}/

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
