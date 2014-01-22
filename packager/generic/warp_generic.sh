#!/bin/sh

SYNTAX="Syntax : $0 warp_name src_directory relative_target_directory"

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

check_export_directory

TARGET_NAME=$1

check_not_empty $TARGET_NAME

SRC_DIRECTORY=$2
check_directory_exists $SRC_DIRECTORY

RELATIVE=$3

check_not_empty $RELATIVE

exit_if_existent $WARP_EXPORT_DIR/$TARGET_NAME

echo "Warp name : $TARGET_NAME"
echo "System dependencies : $SYS_DEPENDENCIES"

run $WARP_HOME/packager/warp_directory.sh $SRC_DIRECTORY current $RELATIVE $TARGET_NAME

