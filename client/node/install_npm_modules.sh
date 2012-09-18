#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

assert_nvm_installed

if [ ! -f package.json ]; then
  echo "No package.json file found, skipping modules installation"
  exit 0
fi

if [ ! `grep dependencies package.json` ]; then
  echo "No dependencies in package.json, skipping modules installation"
  exit 0
fi

load_node_config

if [ -d node_modules ]; then
  echo "This project has already be warped !"
  exit 0
fi

TARGET_NAME=$(generate_npm_modules)

echo "Installing npm modules $LOCAL_NPM_MODULES_HASH"

finalize() {
  cp -r $NVM_DIR/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH node_modules
}

if [ -d $NVM_DIR/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH ]; then
  echo "npm modules $LOCAL_NPM_MODULES_HASH already present"
  finalize
  exit 0
fi

download_and_install $TARGET_NAME

finalize
