#!/bin/bash

KUBECTL_VERSION=${KUBECTL_VERSION:-1.5.2}

docker build --build-arg KUBECTL_VERSION=$KUBECTL_VERSION -t pure/kube-spot-drainer:${KUBECTL_VERSION} .
docker tag  pure/kube-spot-drainer:${KUBECTL_VERSION} pure/kube-spot-drainer:latest
docker push pure/kube-spot-drainer:${KUBECTL_VERSION}
docker push pure/kube-spot-drainer:latest
