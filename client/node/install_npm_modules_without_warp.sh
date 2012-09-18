#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

assert_nvm_installed

load_node_config

nvm_command "nvm use v${LOCAL_NODE_VERSION} && npm install --production"