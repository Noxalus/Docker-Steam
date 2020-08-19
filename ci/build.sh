#!/usr/bin/env sh

set -e
set -x

if [ $CI_COMMIT_TAG ]; then
  export REGISTRY=$CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
elif [ "$CI_COMMIT_REF_NAME" = "master" ]; then
  export REGISTRY=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
else
  export REGISTRY=$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG-$CI_COMMIT_SHORT_SHA
fi

docker build -f Dockerfile --label build-date=`date -Iseconds` --pull -t "$REGISTRY" "."
docker push "$REGISTRY"

if [ "$CI_COMMIT_REF_NAME" = "master" ]; then
  echo "Marking $REGISTRY as latest image"
  docker tag "$REGISTRY" "$CI_REGISTRY_IMAGE:latest"
  docker push "$CI_REGISTRY_IMAGE:latest"
fi