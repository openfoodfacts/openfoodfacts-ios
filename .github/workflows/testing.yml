name: Testing
on:
  pull_request:
    branches:
    - master
jobs:
  test:
    name: Testing Swift Package and iOS app
    runs-on: macOS-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v1
      - name: Force XCode 11.3
        run: sudo xcode-select -switch /Applications/Xcode_11.3.app
      - name: Testing Swift package
        run: exec ./.github/scripts/test_swift_package.sh
      - name: Testing iOS app
        run: exec ./.github/scripts/test_app.sh
