#!/bin/sh
set -e
cd "$(dirname $0)"
git submodule update --init --recursive
