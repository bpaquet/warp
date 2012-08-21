#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

assert_nvm_installed

load_node_config

if [ "$LOCAL_NODE_VERSION" = "" ]; then
  echo "No node version found"
  exit 1
fi

if [ -d $NVM_DIR/v$LOCAL_NODE_VERSION ]; then
  echo "Node $LOCAL_NODE_VERSION is already installed"
  exit 0
fi

TARGET_NAME=$(generate_node_version $LOCAL_NODE_VERSION)

echo "Node version $LOCAL_NODE_VERSION is not installed"

download_and_install $TARGET_NAME
