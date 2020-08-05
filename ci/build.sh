#!/usr/bin/env sh

set -ex

if [ "$CI_COMMIT_REF_NAME" = "master" ]; then
  export REGISTRY=$CI_REGISTRY_IMAGE:$TAG
else
  export REGISTRY=$CI_REGISTRY_IMAGE:$TAG-$CI_COMMIT_REF_SLUG
fi

docker build -f Dockerfile --label build-date=`date -Iseconds` --pull -t "$REGISTRY" "."