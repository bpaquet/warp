#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

assert_rbenv_installed

RUBY_PATH=$1
check_not_empty $RUBY_PATH

check_directory_exists $RUBY_PATH

echo "Adjusting shebangs for $RUBY_PATH"