#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

SYNTAX="Syntax : $0 archive_name directory"

NAME=$1
check_not_empty $NAME

DIRECTORY=$2
check_directory_exists $DIRECTORY

echo "Creating WARP archive $NAME from directory $DIRECTORY"

ARCHIVE=$START_DIR/$NAME.tar.gz
WARP=$START_DIR/$NAME

cd $DIRECTORY

check_not_existent $ARCHIVE
run tar cjf $ARCHIVE ./*

check_not_existent $WARP
cat $WARP_HOME/warper/decomp.sh $ARCHIVE > $WARP
check_result

run rm $ARCHIVE

run chmod +x $WARP

echo `basename $WARP` created.
