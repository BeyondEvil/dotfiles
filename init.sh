#!/bin/bash

echo "Hello World"

if ! xcode-select -p; then
  echo "Installing xcode command line tools..."
  xcode-select --install
fi

echo "Done"
