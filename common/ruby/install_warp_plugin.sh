#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

assert_rbenv_installed

if [ -d $RBENV_DIR/plugins/warp ]; then
  rm -rf $RBENV_DIR/plugins/warp
  check_result
fi

cp -r $WARP_HOME/common/ruby/rbenv-plugin $RBENV_DIR/plugins/warp
check_result
