#!/bin/bash

set -eo pipefail

cd OpenFoodFacts; swift test --parallel; cd ..
