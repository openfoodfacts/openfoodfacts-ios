fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### test
```
fastlane test
```
Run all the tests
### beta
```
fastlane beta
```
Build and send the beta to TestFlight. The script will perform the following actions: 
- Fetch the latest version and build_number from AppStoreConnect
- set the project version to 'release/{version}'
- set the build number to build_number + 1
- build and upload to AppStoreConnect
- commit new version, tag and push
- create a new release in sentry corresponding to the release we just uploaded

If you want a specific version number (for example if you want to bump a major instead of patch by default), set it in the xcode project. It will be taken if it is greater than the version from the current branch. Same goes for the build number.
### refresh_dsyms
```
fastlane refresh_dsyms
```
Upload dsyms to Sentry. This lane needs to be launched when the build has been processed by the AppStoreConnect.
### finalize_sentry_release
```
fastlane finalize_sentry_release
```
Mark the current live version on the app store as "finalized" on Sentry. This lane needs to be launched after a version is "ready for sale" on the AppStore
### metadata
```
fastlane metadata
```
Upload metadata

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
