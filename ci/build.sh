#!/usr/bin/env sh

set -ex

if [ "$CI_COMMIT_REF_NAME" = "master" ]; then
  export REGISTRY=$CI_REGISTRY_IMAGE:$TAG
else
  export REGISTRY=$CI_REGISTRY_IMAGE:$TAG-$CI_COMMIT_REF_SLUG
fi

docker build -f Dockerfile --label build-date=`date -Iseconds` --pull -t "$REGISTRY" "."
docker push "$REGISTRY"

if [ "$CI_COMMIT_REF_NAME" = "master" ] && [ -n "$LATEST" ]; then
  echo "Marking $REGISTRY as latest image"
  docker tag "$REGISTRY" "$CI_REGISTRY_IMAGE:latest"
  docker push "$CI_REGISTRY_IMAGE:latest"
fi
