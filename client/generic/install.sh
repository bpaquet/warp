#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

SYNTAX="$0 warp_name"

WARP_NAME=$1
check_not_empty $WARP_NAME

download_and_install $WARP_NAME
