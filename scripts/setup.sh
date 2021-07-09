#!/bin/bash

# Bash strict mode. See http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Get directory containing this script. See https://stackoverflow.com/a/246128 
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Use mint to install the dependencies, as it allows to pin a specific version (brew only allow to run the latest version)
mint_version="0.14.1"
if [ "$(mint version 2>/dev/null)" != "Version: $mint_version" ]; then
  echo "✨ Installing Mint, version $mint_version"
  git clone -b "$mint_version" https://github.com/yonaskolb/Mint.git # Clone a specific version of Mint
  (cd Mint && make) 
  rm -rf Mint
fi

# Uninstall brew packages that will better be installed with mint
if brew ls --versions carthage > /dev/null; then
  echo "✨ Uninstall carthage installed with brew"
  brew uninstall carthage
fi

echo "✨ Installing mint dependencies"
mint bootstrap -l

set -euo pipefail

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.

CURRENT_XCODE_VERSION=$(xcodebuild -version | grep "Build version" | cut -d' ' -f3)
echo CURRENT_XCODE_VERSION
echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$CURRENT_XCODE_VERSION = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig

echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

export XCODE_XCCONFIG_FILE="$xcconfig"

if [ "$CI" = true ] ; then
  echo "✨ Skipping carthage dependencies as CI=true"
else
  echo "✨ Installing carthage dependencies"
  
  carthage bootstrap --platform iOS --cache-builds --use-xcframeworks
fi

echo "✨ Generating project"
. $SCRIPTS_DIR/create-project.sh
