<img height='175' src="https://raw.githubusercontent.com/openfoodfacts/openfoodfacts-server/af910644fa356e30e22be876100e785cd8a9903f/html/images/misc/openfoodfacts-logo-en.svg" align="left" hspace="1" vspace="1">
<a href="https://apps.apple.com/app/open-food-facts/id588797948"><img height="275" src="https://static.openfoodfacts.org/images/ecoscore/ecoscore_iphone_lasagne.png" align="right" hspace="1" vspace="1"></a>

# Open Food Facts iPhone and iPad app

[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)
[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/openfoodfacts/localized.svg)](https://translate.openfoodfacts.org)
![TestFlight release](https://github.com/openfoodfacts/openfoodfacts-ios/workflows/TestFlight%20release/badge.svg)
<br>


<img height="75" src="https://user-images.githubusercontent.com/7317008/43209852-4ca39622-904b-11e8-8ce1-cdc3aee76ae9.png" align="right" hspace="1" vspace="1">


## What is Open Food Facts? What can I work on ?

[Open Food Facts](https://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.
Open Food Facts on iPhone and iPad has 0,5M users and 1,6M products. Each contribution you make will have a large impact on food transparency worldwide. Finding the right issue or feature will help you have even more more impact. Feel free to ask for feedback on the #android channel before you start work, and to document what you intend to code.

### Features you can work on
- [ ] [Show additives evaluation on cards](https://github.com/openfoodfacts/openfoodfacts-ios/issues/173)
- [ ] [Add a mode to compare 2 (or more) products](https://github.com/openfoodfacts/openfoodfacts-ios/issues/153)
- [ ] Add a [Lists system (shopping list, nutritional intake, scan history…)]((https://github.com/openfoodfacts/openfoodfacts-ios/issues/881)
- [ ] [Add a prompt to extract ingredients when photo is already present](https://github.com/openfoodfacts/openfoodfacts-ios/issues/171) so that we can have a simple way to NOVA, vegetarian, vegan, additive status
- [ ] Finish the [new product page revamp based on the Attributes API](https://github.com/openfoodfacts/openfoodfacts-ios/pull/780)
- [ ] Add support for cosmetics (Open Beauty Facts) and other products [#687](https://github.com/openfoodfacts/openfoodfacts-ios/issues/687) and [#160](https://github.com/openfoodfacts/openfoodfacts-ios/issues/160)
- [ ] [Cache viewed products on-device so that they load fast and regardless of network conditions](https://github.com/openfoodfacts/openfoodfacts-ios/issues/882)

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

### Issues
Here are issues and feature requests you can work on:

#### Search issues
- [ ]  [Disable search as you type: it does not work and causes performance issues on the server P1 bug search](https://github.com/openfoodfacts/openfoodfacts-ios/issues/553)

#### Scan issues
- [ ]  [Card is completely blank if no name/brand/quantity/image is selected](https://github.com/openfoodfacts/openfoodfacts-ios/issues/180)

#### History issues
- [ ]  [Offline scans are not added to your history](https://github.com/openfoodfacts/openfoodfacts-ios/issues/267)
- [ ]  [Allow to export the product history](https://github.com/openfoodfacts/openfoodfacts-ios/issues/53)

#### Product editing issues
- [ ]  [Add a prompt to extract Ingredients when photo is already present](https://github.com/openfoodfacts/openfoodfacts-ios/issues/171)

#### Refactoring issues
- [ ]  [Storyboardify app](https://github.com/openfoodfacts/openfoodfacts-ios/issues/403)
- [ ]  [Try to support iOS 9 again](https://github.com/openfoodfacts/openfoodfacts-ios/issues/115)

#### Onboarding new users
- [ ]  [Add a dynamic changelog](https://github.com/openfoodfacts/openfoodfacts-ios/issues/335)

#### Viewing products
- [ ]  [Traces are not translated](https://github.com/openfoodfacts/openfoodfacts-ios/issues/245)

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
carthage bootstrap --platform iOS --cache-builds` .

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
- [ ]  Create a GitHub Action to run screenshot generation and upload the output to the OFF server (or somewhere else)
- [ ]  fixing the Scan screenshot generation, and adding a way to set the background of the barcode scanner with an arbitrary image, per country
- [ ]  fixing History screenshot population with products
- [ ]  Adding the proposed fix to clean the top bar with 100% battery, and a fixed time
- [ ]  Adding `fastlane frameit` to the Fastlane file, so that we can get versions wrapped in physical devices
- [ ]  fixing Chinese screenshot generation
- [ ]  Ensure we can generate for 1 of (iPhone 11 Pro Max, iPhone 11, iPhone XS Max, iPhone XR), 1 of (iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus), 1 of (3rd generation iPad Pro)
- [ ]  Extra: For debugging purposes, it would be great to have other screen resolutions (iPhone 11 Pro, iPhone X, iPhone XS) (iPhone 6, iPhone 6s, iPhone 7, iPhone 8) (iPhone SE) (iPhone 4s)

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
