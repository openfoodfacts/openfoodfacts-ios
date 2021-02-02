#!/bin/bash

# Bash strict mode. See http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Get directory containing this script. See https://stackoverflow.com/a/246128 
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "✨ Installing carthage dependencies"
carthage bootstrap --platform iOS --cache-builds

echo "✨ Generating project"
. $SCRIPTS_DIR/create-project.sh
