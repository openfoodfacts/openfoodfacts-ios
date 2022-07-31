<img height='175' src="https://raw.githubusercontent.com/openfoodfacts/openfoodfacts-server/af910644fa356e30e22be876100e785cd8a9903f/html/images/misc/openfoodfacts-logo-en.svg" align="left" hspace="1" vspace="1">
<a href="https://apps.apple.com/app/open-food-facts/id588797948"><img height="275" src="https://static.openfoodfacts.org/images/ecoscore/ecoscore_iphone_lasagne.png" align="right" hspace="1" vspace="1"></a>

# (Old) Open Food Facts iPhone and iPad app

The new app is located at https://github.com/openfoodfacts/smooth-app

[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)
[![Project Status](https://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/openfoodfacts/localized.svg)](https://translate.openfoodfacts.org)
![TestFlight release](https://github.com/openfoodfacts/openfoodfacts-ios/workflows/TestFlight%20release/badge.svg)
<br>


<img height="75" src="https://user-images.githubusercontent.com/7317008/43209852-4ca39622-904b-11e8-8ce1-cdc3aee76ae9.png" align="right" hspace="1" vspace="1">


## What is Open Food Facts? What can I work on ?

[Open Food Facts](https://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.
Open Food Facts on iPhone and iPad has 0,5M users and 1,6M products. Each contribution you make will have a large impact on food transparency worldwide. Finding the right issue or feature will help you have even more more impact. Feel free to ask for feedback on the #android channel before you start work, and to document what you intend to code.

### Features you can work on
- [ ] [What can I work on ?](https://github.com/openfoodfacts/openfoodfacts-ios/issues/912)

## Join the team !

OpenFoodFacts [has a Slack chat room where we discuss and support each other](https://slack.openfoodfacts.org/), join the #iOS and #iOS-alerts channels. 

## Current features

- [x] Barcode scanning (including a simple offline mode)
- [x] NOVA, Nutri-Score and Eco-Score display (including in grey if we don't have them yet for the product)
- [x] Ingredient analysis with a simple way to get it if not available
- [x] Product page (needs revamping)
- [x] Search for products based on name
- [x] Allergen alerts (would need to be more discoverable)
- [x] Internationalised user interface & multilingual products handling (view & data addition)
- [x] Product addition & editing (incl. on-the-fly OCR of ingredients and labels, plus integration of the OFF AI)
- [x] Image upload
- [x] Night mode

## Code documentation
[Automatically generated code documentation on the wiki](https://github.com/openfoodfacts/openfoodfacts-ios/wiki/)

## Building

### Quick & automatic setup
The easiest way to setup the dependencies of the project and generate the Xcode project is to run `sh scripts/setup.sh` from the top of the repository, before opening the project in Xcode. 

#### Dependency Management - Carthage

We currently use [Carthage](https://github.com/Carthage/Carthage) for dependency management.
New to Carthage? Others have found the following resources helpful:
* [Ray Wenderlich's Carthage Tutorial](https://www.raywenderlich.com/416-carthage-tutorial-getting-started)
* [Chris Mendez's Carthage cheat sheet](https://www.chrisjmendez.com/2016/10/30/carthage-cheat-sheet/)

Before opening the project in Xcode, run 
`
brew install carthage
`

`
carthage bootstrap --platform iOS --cache-builds
`

To generate the Xcode project run `sh scripts/create-project.sh`.
In order to generate the Xcode project we use [XcodeGen](https://www.github.com/yonaskolb/XcodeGen).
  
### Fastlane
See the [fastlane/README.md](fastlane/README.md) for a list and description of all lanes. 

To launch a lane, you must have several env variable set. This can be done by creating a `.env` file in the `fastlane` folder, and fill it (see `.env.example`)

You can install [Fastlane](https://github.com/fastlane/fastlane) with Homebrew:
```
brew cask install fastlane
```
#### Generating screenshots
```
fastlane snapshot 
```
##### Roadmap on automatic screenshot generation:
* [Our priorities](https://github.com/openfoodfacts/openfoodfacts-ios/issues/913)
* [Configuration file](https://github.com/openfoodfacts/openfoodfacts-ios/blob/01ea37e5247978a52d491181bb7dd2fb384214af/Snapshots/SnapshotConfiguration.swift)

### Style and conventions - SwiftLint

A script runs when building the app that executes SwiftLint to enforce style & conventions to the code.

You can install [SwiftLint](https://github.com/realm/SwiftLint/) with Homebrew:
```
brew install swiftlint
```

### Error reporting - Sentry
[Track crashes](https://sentry.io/organizations/openfoodfacts/issues/?project=5276492)

### Translations

You can [help translate](https://translate.openfoodfacts.org) Open Food Facts (no technical knowledge required, takes a minute to signup).
