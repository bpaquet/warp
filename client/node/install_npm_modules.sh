#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

assert_nvm_installed

check_existent package.json

load_node_config

if [ -h node_modules ]; then
  if ls node_modules/ > /dev/null 2>&1 ; then
    echo "This project has already be warped !"
    exit 0
  fi
  rm node_modules
fi

TARGET_NAME=$(generate_npm_modules)

echo "Installing npm modules $LOCAL_NPM_MODULES_HASH"

finalize() {
  ln -s $NVM_DIR/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH node_modules
}

if [ -d $NVM_DIR/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH ]; then
  echo "npm modules $LOCAL_NPM_MODULES_HASH already present"
  finalize
  exit 0
fi

download_and_install $TARGET_NAME

finalize
