#!/bin/bash

set -eo pipefail

xcodebuild -workspace OpenFoodFacts.xcworkspace \
            -scheme OpenFoodFacts\
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty
