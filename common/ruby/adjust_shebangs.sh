#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

assert_rbenv_installed

SYNTAX="$0 path"

RUBY_PATH=$1
check_not_empty $RUBY_PATH

check_directory_exists $RUBY_PATH

BIN_PATH=$RUBY_PATH/bin
check_directory_exists $BIN_PATH

echo "Adjusting shebangs for $RUBY_PATH"

SLASH_HOME_PATH=`cd $HOME && pwd | sed -e 's/\//\\\\\//g'`

for i in `ls $BIN_PATH`; do
  if [ `file -b $BIN_PATH/$i | awk '{print $1}'` != "ELF" ]; then
    sed -i -e "s/^#!\/.*\/\.rbenv\/versions\//#!${SLASH_HOME_PATH}\/.rbenv\/versions\//" $BIN_PATH/$i
  fi
done