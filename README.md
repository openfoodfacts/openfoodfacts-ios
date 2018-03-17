# Open Food Facts iOS app
[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)

[Open Food Facts](http://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.

## Features

- [x] Barcode scanning
- [x] Product search
- [x] Product list
- [x] Product detail
- [ ] On-device Product cache
- [x] Image upload
- [ ] Internationalised user interface

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

OpenFoodFacts has a Slack team, join the #iOS channel. Click [here](https://slack-ssl-openfoodfacts.herokuapp.com/) to join.
