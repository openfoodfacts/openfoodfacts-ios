# Open Food Facts iOS app
[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)

[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Stories in Ready](https://badge.waffle.io/openfoodfacts/openfoodfacts-ios.svg?label=ready&title=Ready)](https://waffle.io/openfoodfacts/openfoodfacts-ios)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Average time to resolve an issue")
[![Percentage of issues still open](https://isitmaintained.com/badge/open/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Percentage of issues still open")
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/openfoodfacts/localized.svg)](https://crowdin.com/project/openfoodfacts)
<br>
<img src="https://static.openfoodfacts.org/images/misc/openfoodfacts-logo-en-178x150.png">
## What is Open Food Facts?

[Open Food Facts](http://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.


### Translate Open Food Facts in your language

You can help translate Open Food Facts and the app at (no technical knowledge required, takes a minute to signup): <br>
https://crowdin.com/project/openfoodfacts

## Features implemented

- [x] Barcode scanning
- [x] Product search
- [x] Product list
- [x] Product detail
- [x] Image upload


## Roadmap
- [ ] On-the-fly OCR of ingredients and labels for new product addition
- [ ] Internationalised user interface
- [ ] Support for Open Beauty Facts, Open Pet Food Facts and Open Product Facts
- [ ] Native editing
- [ ] On-device Product cache
- [ ] ARKit overlay
- [ ] Handle multilingual products (view)
- [ ] Handle multilingual products (data addition)
- [ ] Add support for the new JSON taxonomy system (multilingual, and data augmentation from Wikipedia/Wikidata)
- [ ] Add a food category browser

## Images

<img src="https://user-images.githubusercontent.com/1689815/37554229-dde0ecb6-29d5-11e8-82e1-918ee97cecd1.png" height="300"><img src="https://user-images.githubusercontent.com/1689815/37554225-ce5822c8-29d5-11e8-92e9-5c667be57a56.png" height="300"><img src="https://user-images.githubusercontent.com/1689815/37554236-f82dea42-29d5-11e8-89d5-4ca6416581d9.png" height="300"><img src="https://user-images.githubusercontent.com/1689815/37554231-e3689670-29d5-11e8-876f-c8d4055f7484.png" height="300"><img src="https://user-images.githubusercontent.com/1689815/37554234-eb159e18-29d5-11e8-8a75-3656742c1efa.png" height="300"><img src="https://user-images.githubusercontent.com/1689815/37554235-f01690fc-29d5-11e8-8319-1aa338708ebb.png" height="300">


## Building

### Dependencies
We use Carthage for dependency management.

Run `carthage bootstrap --platform iOS --cache-builds` before opening the project in Xcode.

You can install [Carthage](https://github.com/Carthage/Carthage) with Homebrew:
```
brew install carthage
```

### Fastlane

Currently there are two lanes, one for running the tests (`fastlane test`) and one for uploading a new beta to TestFlight (`fastlane beta`).

You can install [Fastlane](https://github.com/fastlane/fastlane) with Homebrew:
```
brew cask install fastlane
```

### SwiftLint

We have a script that runs when building the app, it executes SwiftLint to enforce a style and conventions to the code.

You can install [SwiftLint](https://github.com/realm/SwiftLint/) with Homebrew:
```
brew install swiftlint
```

## Support

OpenFoodFacts has a Slack team, join the #iOS and #iOS-alerts channels. Click [here](https://slack.openfoodfacts.org/) to join.
