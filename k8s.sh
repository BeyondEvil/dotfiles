#!/usr/bin/env bash

set -eo pipefail

IFS=$'\n' read -r -d '' -a formulae << 'END' || :
helm
jsonnet
jsonnet-bundler
kubectl
kubectx
stern
tanka
END

echo "Installing Kubernetes tooling"
brew install "${formulae[@]}"
