#!/bin/sh -e

START_DIR=`pwd`

cd `dirname $0`
DIRNAME=`pwd`
DECOMP_SCRIPT=$DIRNAME/decomp.sh

cd $START_DIR

SYNTAX="Syntax : $0 archive_name directory"

NAME=$1
if [ "$NAME" = "" ]; then
  echo $SYNTAX
  exit 1
fi

DIRECTORY=$2
if [ ! -d $DIRECTORY ]; then
  echo $SYNTAX
  exit 1
fi

echo "Creating WARP archive $NAME from $DIRECTORY"

ARCHIVE=$START_DIR/$NAME.tar.gz
WARP=$START_DIR/$NAME.warp

cd $DIRECTORY

tar czf $ARCHIVE ./*

cat $DECOMP_SCRIPT $ARCHIVE > $WARP
rm $ARCHIVE

chmod +x $WARP

echo `basename $WARP` created.
