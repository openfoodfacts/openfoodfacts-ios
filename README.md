# Open Food Facts iOS app

Note: Xcode's limited Markdown support means this file is best viewed on GitHub.

[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)
[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Average time to resolve an issue")
[![Percentage of issues still open](https://isitmaintained.com/badge/open/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Percentage of issues still open")
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/openfoodfacts/localized.svg)](https://crowdin.com/project/openfoodfacts)

![Open Food Facts icon](https://static.openfoodfacts.org/images/misc/openfoodfacts-logo-en-178x150.png)

[![Download on the App Store](https://user-images.githubusercontent.com/7317008/43209852-4ca39622-904b-11e8-8ce1-cdc3aee76ae9.png)](https://apps.apple.com/app/open-food-facts/id588797948)

## What is Open Food Facts?

[Open Food Facts](https://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.

### Translate Open Food Facts in your language

You can help translate Open Food Facts and the app at (no technical knowledge required, takes a minute to signup): [translate.openfoodfacts.org](https://translate.openfoodfacts.org)

## Features

- [x] (Offline) Barcode scanning
- [x] Product search
- [x] Allergen alert
- [x] Product details
- [x] Image upload
- [x] Handle multilingual products (view)
- [x] Handle multilingual products (data addition)
- [x] On-the-fly OCR of ingredients and labels for new product addition
- [x] Internationalised user interface
- [x] Native editing
- [x] Night mode

## Priority roadmap
- [ ] Vegan/vegetarian/palm oil (ready server side) [issue #321](https://github.com/openfoodfacts/openfoodfacts-ios/issues/321)
- [ ] Additives evaluation (already ready server side and on Android) [issue #173](https://github.com/openfoodfacts/openfoodfacts-ios/issues/173)
- [ ] Compare Mode [issue #153](https://github.com/openfoodfacts/openfoodfacts-ios/issues/153)
- [ ] Product lists (to buy, eaten…)

## Secondary roadmap
- [ ] On-device Product cache
- [ ] Add a food category browser
- [ ] Add support for the new JSON taxonomy system (multilingual, and data augmentation from Wikipedia/Wikidata)
- [ ] Support for Open Beauty Facts, Open Pet Food Facts and Open Product Facts

## Images

![First App Store screenshot](https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e7/18/27/e71827cd-1fd4-5b81-b52e-2668feed9700/pr_source.png/230x0w.png)
![Second App Store screenshot](https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/98/11/48/9811480a-d2a7-0050-f094-7f22809d532d/pr_source.png/230x0w.png)
![Third App Store screenshot](https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/d0/f6/45/d0f64585-caec-2201-43e1-098ce809f1cc/pr_source.png/230x0w.png)
![Fourth App Store screenshot](https://is3-ssl.mzstatic.com/image/thumb/Purple124/v4/4b/29/e9/4b29e937-ac81-ec04-218c-3747e6e041a2/pr_source.png/230x0w.png)
![Fifth App Store screenshot](https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/9f/cc/76/9fcc763c-5abf-d01a-6397-16a35599099a/pr_source.png/230x0w.png)

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
