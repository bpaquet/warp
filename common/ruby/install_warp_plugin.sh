#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

assert_rbenv_installed

# old way
if [ -d $RBENV_DIR/plugins/warp ]; then
  run rm -rf $RBENV_DIR/plugins/warp
fi

if [ -d $RBENV_DIR/plugins/00warp ]; then
  run rm -rf $RBENV_DIR/plugins/00warp
fi

run cp -r $WARP_HOME/common/ruby/rbenv-plugin $RBENV_DIR/plugins/00warp
