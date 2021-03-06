#!/bin/bash -xe

docker_tag="parallelssh/ssh2-manylinux"

rm -rf build ssh2/libssh2.*
python ci/appveyor/fix_version.py .

docker pull $docker_tag || echo
docker build --cache-from $docker_tag ci/docker/manylinux -t $docker_tag
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then docker push $docker_tag; fi
docker run -e TRAVIS_TAG="$TRAVIS_TAG" --rm -v `pwd`:/io $docker_tag /io/ci/travis/build-wheels.sh
ls wheelhouse/
