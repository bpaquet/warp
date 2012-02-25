#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

assert_rbenv_installed

if [ "`ls $RBENV_DIR/versions | wc -l`" = "1" ]; then
  VERSION=`ls $RBENV_DIR/versions`
  echo "Only one ruby version detected : $VERSION"
  $HOME/.rbenv/bin/rbenv global $VERSION
  echo "Version $VERSION setted as global"
fi