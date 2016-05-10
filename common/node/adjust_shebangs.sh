#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

SYNTAX="$0 path"

NODE_PATH=$1
check_not_empty $NODE_PATH

check_directory_exists $NODE_PATH

BIN_PATH=$NODE_PATH/bin
check_directory_exists $BIN_PATH

echo "Adjusting shebangs for $NODE_PATH"

SLASH_HOME_PATH=`cd $HOME && pwd | sed -e 's/\//\\\\\//g'`

for i in `ls $BIN_PATH`; do
  if [ `file -b $BIN_PATH/$i | awk '{print $1}'` != "ELF" ]; then
    sed --follow-symlinks -i -e "s/^#!\/.*\/\.nvm\/v/#!${SLASH_HOME_PATH}\/.nvm\/v/" $BIN_PATH/$i
  fi
done