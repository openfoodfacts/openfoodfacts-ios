<img height='175' src="https://static.openfoodfacts.org/images/misc/openfoodfacts-logo-en-178x150.png" align="left" hspace="1" vspace="1">

# Open Food Facts iOS app

Note: Xcode's limited Markdown support means this file is best viewed on GitHub. Not seeing this as a formatted file in Xcode? Check out [the Build section](https://github.com/openfoodfacts/openfoodfacts-ios/wiki/Build) of the project wiki on GitHub for troubleshooting tips.

[![Build Status](https://travis-ci.org/openfoodfacts/openfoodfacts-ios.svg?branch=master)](https://travis-ci.org/openfoodfacts/openfoodfacts-ios)
[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Average time to resolve an issue")
[![Percentage of issues still open](https://isitmaintained.com/badge/open/openfoodfacts/openfoodfacts-ios.svg)](https://isitmaintained.com/project/openfoodfacts/openfoodfacts-ios "Percentage of issues still open")
[![Crowdin](https://d322cqt584bo4o.cloudfront.net/openfoodfacts/localized.svg)](https://crowdin.com/project/openfoodfacts)

<a href="https://apps.apple.com/app/open-food-facts/id588797948"><img height="75" src="https://user-images.githubusercontent.com/7317008/43209852-4ca39622-904b-11e8-8ce1-cdc3aee76ae9.png" align="left" hspace="1" vspace="1"></a>

## What is Open Food Facts?

[Open Food Facts](https://world.openfoodfacts.org/) is a food products database made by everyone, for everyone.

### Help translate Open Food Facts in your language

You can help translate Open Food Facts and the app at (no technical knowledge required, takes a minute to signup): [translate.openfoodfacts.org](https://translate.openfoodfacts.org)

## Features

- [x] Offline barcode scanning
- [x] Product search
- [x] Allergen alert
- [x] Product details
- [x] Image upload
- [x] Handle multilingual products (view)
- [x] Handle multilingual products (data addition)
- [x] On-the-fly OCR of ingredients and labels for new product addition
- [x] Internationalised user interface
- [x] Native editing
- [x] Product addition
- [x] Night mode

## What can I work on ?

Open Food Facts on iPhone and iPad has 0,5M users and 1M products. Each contribution you make will have a large impact on food transparency worldwide. Finding the right issue or feature will help you have even more more impact. Feel free to ask for feedback on the #android channel before you start work, and to document what you intend to code.

### Priority roadmap
- [ ] Additives evaluation (already ready server side and on Android) [issue #173](https://github.com/openfoodfacts/openfoodfacts-ios/issues/173)
- [ ] Compare Mode [issue #153](https://github.com/openfoodfacts/openfoodfacts-ios/issues/153)
- [ ] Product lists (to buy, eaten…)  

### Secondary roadmap
- [ ] On-device Product cache
- [ ] Add a food category browser
- [ ] Add support for the new JSON taxonomy system (multilingual, and data augmentation from Wikipedia/Wikidata)
- [ ] Support for Open Beauty Facts, Open Pet Food Facts and Open Product Facts

### Issues
Here are issues and feature requests you can work on:

#### Search issues
- [Disable search as you type: it does not work and causes performance issues on the server P1 bug search](https://github.com/openfoodfacts/openfoodfacts-ios/issues/553)

#### Scan issues
- [Card is completely blank if no name/brand/quantity/image is selected](https://github.com/openfoodfacts/openfoodfacts-ios/issues/180)

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


## Images

![First App Store screenshot](https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e7/18/27/e71827cd-1fd4-5b81-b52e-2668feed9700/pr_source.png/230x0w.png)
![Second App Store screenshot](https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/98/11/48/9811480a-d2a7-0050-f094-7f22809d532d/pr_source.png/230x0w.png)
![Third App Store screenshot](https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/d0/f6/45/d0f64585-caec-2201-43e1-098ce809f1cc/pr_source.png/230x0w.png)
![Fourth App Store screenshot](https://is3-ssl.mzstatic.com/image/thumb/Purple124/v4/4b/29/e9/4b29e937-ac81-ec04-218c-3747e6e041a2/pr_source.png/230x0w.png)
![Fifth App Store screenshot](https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/9f/cc/76/9fcc763c-5abf-d01a-6397-16a35599099a/pr_source.png/230x0w.png)

## Building

### Automatic setup
The easiest way to setup the dependencies of the project and generate the Xcode project is to run `sh scripts/setup.sh` from the top of the repository.

### Manual setup
If you prefer to not use the `sh scripts/setup.sh` script and install the dependencies yourself, follow the instructions below.

We use Carthage for dependency management.

Run `carthage bootstrap --platform iOS --cache-builds` before opening the project in Xcode.

You can install [Carthage](https://github.com/Carthage/Carthage) with Homebrew:
```
brew install carthage
```

To generate the Xcode project run `sh scripts/create-project.sh`.
In order to generate the Xcode project we use [XcodeGen](https://www.github.com/yonaskolb/XcodeGen).

#### Carthage resources
New to Carthage? Others have found the following resources helpful:
* [Ray Wenderlich's Carthage Tutorial](https://www.raywenderlich.com/416-carthage-tutorial-getting-started)
* [Chris Mendez's Carthage cheat sheet](https://www.chrisjmendez.com/2016/10/30/carthage-cheat-sheet/)
  
### Fastlane

Currently there are two lanes, one for running the tests (`fastlane test`) and one for uploading a new beta to TestFlight (`fastlane beta`).

You can install [Fastlane](https://github.com/fastlane/fastlane) with Homebrew:
```
brew cask install fastlane
```
#### Generating screenshots
```
fastlane snapshot 
```
##### Roadmap on automatic screenshot generation:
- [ ]  fixing the [non translatable scan product button](https://github.com/openfoodfacts/openfoodfacts-ios/issues/651) so that the screenshot and the app are fully translated
- [ ]  fixing the Scan screenshot generation, and adding a way to set the background of the barcode scanner with an arbitrary image, per country
- [ ]  fixing History screenshot population with products
- [ ]  Adding the proposed fix to clean the top bar with 100% battery, and a fixed time
- [ ]  Adding `fastlane frameit` to the Fastlane file, so that we can get versions wrapped in physical devices
- [ ]  fixing Chinese screenshot generation
- [ ]  Ensure we can generate for 1 of (iPhone 11 Pro Max, iPhone 11, iPhone XS Max, iPhone XR), 1 of (iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus), 1 of (3rd generation iPad Pro)
- [ ]  Extra: For debugging purposes, it would be great to have other screen resolutions (iPhone 11 Pro, iPhone X, iPhone XS) (iPhone 6, iPhone 6s, iPhone 7, iPhone 8) (iPhone SE) (iPhone 4s)

### SwiftLint

We have a script that runs when building the app, it executes SwiftLint to enforce a style and conventions to the code.

You can install [SwiftLint](https://github.com/realm/SwiftLint/) with Homebrew:
```
brew install swiftlint
```

## Support

OpenFoodFacts has a Slack team where we chat, discuss and support each other, join the #iOS and #iOS-alerts channels. [Click here to join.](https://slack.openfoodfacts.org/)
