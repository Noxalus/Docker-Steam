#!/usr/bin/env sh

set -ex

docker push "$REGISTRY"

if [ "$CI_COMMIT_REF_NAME" = "master" ]; then
  echo "Marking $REGISTRY as latest image"
  docker tag "$REGISTRY" "$CI_REGISTRY_IMAGE:latest"
  docker push "$CI_REGISTRY_IMAGE:latest"
fi