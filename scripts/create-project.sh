#!/bin/bash

killall Xcode || true
rm -rf OpenFoodFacts.xcodeproj 
xcodegen
open OpenFoodFacts.xcodeproj

