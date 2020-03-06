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

echo "✨ Installing carthage dependencies"
carthage bootstrap --platform iOS --cache-builds

echo "✨ Generating project"
. $SCRIPTS_DIR/create-project.sh
