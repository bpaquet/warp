#!/bin/sh -e

DIRNAME=`dirname $0`

if [ "$NO_WARP" = "" ]; then
  $DIRNAME/install_node.sh
  $DIRNAME/install_npm_modules.sh
else
  $DIRNAME/install_node_without_warp.sh
  $DIRNAME/install_npm_modules_without_warp.sh
fi