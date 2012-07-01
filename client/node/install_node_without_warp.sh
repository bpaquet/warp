#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

assert_nvm_installed

load_node_config

if [ -d $NVM_DIR/v$LOCAL_NODE_VERSION ]; then
  echo "NVM $LOCAL_NODE_VERSION is already installed"
  exit 0
fi

nvm_command "nvm install v${LOCAL_NODE_VERSION}"