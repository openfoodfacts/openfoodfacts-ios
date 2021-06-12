#!/bin/bash

set -eo pipefail

xcodebuild -workspace OpenFoodFacts.xcworkspace \
            -scheme OpenFoodFacts\
            -destination platform=iOS\ Simulator,name=iPhone\ 8 \
            clean test | xcpretty
